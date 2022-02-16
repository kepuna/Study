//
//  ZZAudioUnitFileHandler.m
//  ZZKit
//
//  Created by MOMO on 2021/5/6.
//  Copyright © 2021 donews. All rights reserved.
//

#import "ZZAudioUnitFileHandler.h"

static const NSString *kModuleName = @"Audio Unit";

@interface ZZAudioUnitFileHandler ()
{
    AudioFileID m_recordFile;
    SInt64      m_recordCurrentPacket; // current packet number in record file
}

@property (nonatomic, copy) NSString *recordFilePath;

@end

@implementation ZZAudioUnitFileHandler
SingletonM

#pragma mark - Init
+ (instancetype)getInstance {
    return [[self alloc] init];
}

#pragma mark - Public

- (void)writeFileWithInNumBytes:(UInt32)inNumBytes ioNumPackets:(UInt32)ioNumPackets inBuffer:(const void *)inBuffer inPacketDesc:(const AudioStreamPacketDescription *)inPacketDesc {
    
    if (!m_recordFile) {
        return;
    }
    
    // AudioStreamPacketDescription outputPacketDescriptions;
    OSStatus status = AudioFileWritePackets(m_recordFile, false, inNumBytes, inPacketDesc, m_recordCurrentPacket, &ioNumPackets, inBuffer);
    
    if (status == noErr) {
        m_recordCurrentPacket += ioNumPackets;  // 用于记录起始位置
    }else {
        NSLog(@"%@:%s - write file status = %d \n",kModuleName,__func__,(int)status);
    }
}

- (void)startRecordVoiceByAudioUnitByAudioConverter:(AudioConverterRef)audioConverter needMagicCookie:(BOOL)isNeedMagicCookie audioDesc:(AudioStreamBasicDescription)audioDesc {
    
    self.recordFilePath = [self createFilePath];
    
    m_recordFile = [self createAudioFileWithFilePath:self.recordFilePath audioDesc:audioDesc];
    
    if (isNeedMagicCookie) {
        // add magic cookie contain header file info for VBR data
        [self copyEncoderCookieToFileByAudioConverter:audioConverter inFile:m_recordFile];
    }
}

- (void)stopVoiceRecordAudioConverter:(AudioConverterRef)audioConverter needMagicCookie:(BOOL)isNeedMagicCookie {
    if (isNeedMagicCookie) {
        // reconfirm magic cookie at the end.
        [self copyEncoderCookieToFileByAudioConverter:audioConverter
                                               inFile:m_recordFile];
    }
    AudioFileClose(m_recordFile);
    m_recordCurrentPacket = 0;
}


#pragma mark - Private
#pragma mark File Path
- (NSString *)createFilePath {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy_MM_dd__HH_mm_ss";
    NSString *date = [dateFormatter stringFromDate:[NSDate date]];
    
    NSArray *searchPaths    = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask,
                                                                  YES);
    
    NSString *documentPath  = [[searchPaths objectAtIndex:0] stringByAppendingPathComponent:@"Voice"];
    
    // 先创建子目录. 注意,若果直接调用AudioFileCreateWithURL创建一个不存在的目录创建文件会失败
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:documentPath]) {
        [fileManager createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *fullFileName  = [NSString stringWithFormat:@"%@.caf",date];
    NSString *filePath      = [documentPath stringByAppendingPathComponent:fullFileName];
    return filePath;
}

- (AudioFileID)createAudioFileWithFilePath:(NSString *)filePath audioDesc:(AudioStreamBasicDescription)audioDesc {

    CFURLRef url = CFURLCreateWithString(kCFAllocatorDefault, (CFStringRef)filePath, NULL);
    
    NSLog(@"%@:%s - record file path:%@",kModuleName,__func__,filePath);
    
    AudioFileID audioFile;
    // create the audio file
    // 枚举 kAudioFileCAFType ？？？
    // 枚举 kAudioFileFlags_EraseFile ？？？
    OSStatus status = AudioFileCreateWithURL(url, kAudioFileCAFType, &audioDesc, kAudioFileFlags_EraseFile, &audioFile);
    
    if (status != noErr) {
        NSLog(@"%@:%s - AudioFileCreateWithURL Failed, status:%d",kModuleName,__func__,(int)status);
    }
    CFRelease(url);
    return audioFile;
}

- (void)copyEncoderCookieToFileByAudioConverter:(AudioConverterRef)audioConverter inFile:(AudioFileID)inFile {
    
    // Grab the cookie from the converter and write it to the destination file.
    UInt32 cookieSize = 0;
    OSStatus error = AudioConverterGetPropertyInfo(audioConverter, kAudioConverterCompressionMagicCookie, &cookieSize, NULL);
    
    if (error == noErr && cookieSize != 0) {
        char *cookie = (char *)malloc(cookieSize * sizeof(char));
        error = AudioConverterGetProperty(audioConverter, kAudioConverterCompressionMagicCookie, &cookieSize, cookie);
        if (error == noErr) {
            error = AudioFileSetProperty(inFile, kAudioFilePropertyMagicCookieData, cookieSize, cookie);
            if (error == noErr) {
                UInt32 willEatTheCookie = false;
                error = AudioFileGetPropertyInfo(inFile, kAudioFilePropertyMagicCookieData, NULL, &willEatTheCookie);
                if (error == noErr) {
                    NSLog(@"%@:%s - Writing magic cookie to destination file: %u   cookie:%d \n",kModuleName,__func__, (unsigned int)cookieSize, willEatTheCookie);
                } else {
                    NSLog(@"%@:%s - Could not Writing magic cookie to destination file status:%d \n",kModuleName,__func__,(int)error);
                }
                
            } else {
                NSLog(@"%@:%s - Even though some formats have cookies, some files don't take them and that's OK,set cookie status:%d \n",kModuleName,__func__,(int)error);
            }
            
        } else {
            NSLog(@"%@:%s - Could not Get kAudioConverterCompressionMagicCookie from Audio Converter!\n status:%d ",kModuleName,__func__,(int)error);
        }
        free(cookie);
        
    } else {
        // If there is an error here, then the format doesn't have a cookie - this is perfectly fine as som formats do not.
        NSLog(@"%@:%s - cookie status:%d, %d \n",kModuleName,__func__,(int)error, cookieSize);
    }
}

@end
