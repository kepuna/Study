//
//  ZZAudioFileHandler.m
//  ZZKit
//
//  Created by MOMO on 2021/4/30.
//  Copyright © 2021 donews. All rights reserved.
//

#import "ZZAudioFileHandler.h"

static const NSString *kModuleName = @"Audio File";

@interface ZZAudioFileHandler ()
{
    AudioFileID m_recordFile;
    SInt64      m_recordCurrentPacket; // current packet number in record file
}

@property (nonatomic, copy) NSString *recordFilePath;

@end

@implementation ZZAudioFileHandler
SingletonM

#pragma mark - Init
+ (instancetype)getInstance {
    return [[self alloc] init];
}


#pragma mark - Public Method

- (void)writeFileWithInNumBytes:(UInt32)inNumBytes ioNumPackets:(UInt32)ioNumPackets inBuffer:(const void *)inBuffer inPacketDesc:(const AudioStreamPacketDescription *)inPacketDesc {
    if (!m_recordFile) {
        return;
    }
    OSStatus status = AudioFileWritePackets(m_recordFile,
                                            false,
                                            inNumBytes,
                                            inPacketDesc,
                                            m_recordCurrentPacket,
                                            &ioNumPackets,
                                            inBuffer);
    if (status == noErr) {
        m_recordCurrentPacket += ioNumPackets; // 用于记录起始位置
    } else {
        NSLog(@"%@:%s - write file status = %d \n",kModuleName,__func__,(int)status);
    }
}

- (void)startRecordVoiceByAudioQueue:(AudioQueueRef)audioQueue isNeedMagicCookie:(BOOL)isNeedMagicCookie audioDesc:(AudioStreamBasicDescription)audioDesc {
    self.recordFilePath = [self _createFilePath];
    NSLog(@"%@:%s - record file path:%@",kModuleName,__func__,self.recordFilePath);
    
    // create the audio file
    m_recordFile = [self _createAudioFileWithFilePath:self.recordFilePath audioDesc:audioDesc];
    
    if (isNeedMagicCookie) {
        // ？？？ ⚠️ add magic cookie contain header file info for VBR data
        [self copyEncoderCookieToFileByAudioQueue:audioQueue
                                           inFile:m_recordFile];
        
    }
}

- (void)stopVoiceRecordByAudioQueue:(AudioQueueRef)audioQueue isNeedMagicCookie:(BOOL)isNeedMagicCookie {
    if (isNeedMagicCookie) {
        // reconfirm magic cookie at the end.
        [self copyEncoderCookieToFileByAudioQueue:audioQueue inFile:m_recordFile];
    }
    AudioFileClose(m_recordFile);
    m_recordCurrentPacket = 0;
}

#pragma mark Magic Cookie

- (void)copyEncoderCookieToFileByAudioQueue:(AudioQueueRef)inQueue inFile:(AudioFileID)inFile {
    OSStatus result = noErr;
    UInt32 cookieSize;
    
    result = AudioQueueGetPropertySize(inQueue, kAudioQueueProperty_MagicCookie, &cookieSize);
    if (result != noErr) {
        NSLog(@"%@:%s - Magic cookie: get size failed.",kModuleName,__func__);
        return;
    }
    
    char *magicCookie = (char *)malloc(cookieSize);
    result = AudioQueueGetProperty(inQueue, kAudioQueueProperty_MagicCookie, magicCookie, &cookieSize);
    if (result != noErr) {
        NSLog(@"%@:%s - get Magic cookie failed.",kModuleName,__func__);
        free(magicCookie);
        return;
    }
    
    result = AudioFileSetProperty(inFile, kAudioFilePropertyMagicCookieData, cookieSize, magicCookie);
    if (result != noErr) {
        NSLog(@"%@:%s - set Magic cookie failed.",kModuleName,__func__);
        free(magicCookie);
        return;
    }
}


#pragma mark - Private Method

- (AudioFileID)_createAudioFileWithFilePath:(NSString *)filePath audioDesc:(AudioStreamBasicDescription)audioDesc {
    CFURLRef url = CFURLCreateWithString(kCFAllocatorDefault, (CFStringRef)filePath, NULL);
    NSLog(@"%@:%s - record file path:%@",kModuleName,__func__,filePath);
    
    AudioFileID audioFile;
    // create audio file
    // ?? kAudioFileCAFType 枚举
    // ??? kAudioFileFlags_EraseFile
    OSStatus status = AudioFileCreateWithURL(url, kAudioFileCAFType, &audioDesc, kAudioFileFlags_EraseFile, &audioFile);
    if (status != noErr) {
        NSLog(@"%@:%s - AudioFileCreateWithURL Failed, status:%d",kModuleName,__func__,(int)status);
    }
    CFRelease(url);
    return audioFile;
}

- (NSString *)_createFilePath {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy_MM_dd__HH_mm_ss";
    NSString *date = [dateFormatter stringFromDate:[NSDate date]];
    
    NSArray *searchPaths    = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask,
                                                                  YES);
    
    NSString *documentPath  = [[searchPaths objectAtIndex:0] stringByAppendingPathComponent:@"Voice"];
    
    // 先创建子目录. 注意,若果直接调用AudioFileCreateWithURL创建一个不存在的目录创建文件会失败
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if (![fileManager fileExistsAtPath:documentPath]) {
        [fileManager createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    if (error) {
        return nil;
    }
    
    NSString *fullFileName = [NSString stringWithFormat:@"%@.caf",date];
    return [documentPath stringByAppendingPathComponent:fullFileName];
}

@end
