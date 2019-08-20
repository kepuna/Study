//
//  YYClassInfo.h
//  YYModel <https://github.com/ibireme/YYModel>
//
//  Created by ibireme on 15/5/9.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Type encoding's type.
 */
typedef NS_OPTIONS(NSUInteger, DNAdYYEncodingType) {
    DNAdYYEncodingTypeMask       = 0xFF, ///< mask of type value
    DNAdYYEncodingTypeUnknown    = 0, ///< unknown
    DNAdYYEncodingTypeVoid       = 1, ///< void
    DNAdYYEncodingTypeBool       = 2, ///< bool
    DNAdYYEncodingTypeInt8       = 3, ///< char / BOOL
    DNAdYYEncodingTypeUInt8      = 4, ///< unsigned char
    DNAdYYEncodingTypeInt16      = 5, ///< short
    DNAdYYEncodingTypeUInt16     = 6, ///< unsigned short
    DNAdYYEncodingTypeInt32      = 7, ///< int
    DNAdYYEncodingTypeUInt32     = 8, ///< unsigned int
    DNAdYYEncodingTypeInt64      = 9, ///< long long
    DNAdYYEncodingTypeUInt64     = 10, ///< unsigned long long
    DNAdYYEncodingTypeFloat      = 11, ///< float
    DNAdYYEncodingTypeDouble     = 12, ///< double
    DNAdYYEncodingTypeLongDouble = 13, ///< long double
    DNAdYYEncodingTypeObject     = 14, ///< id
    DNAdYYEncodingTypeClass      = 15, ///< Class
    DNAdYYEncodingTypeSEL        = 16, ///< SEL
    DNAdYYEncodingTypeBlock      = 17, ///< block
    DNAdYYEncodingTypePointer    = 18, ///< void*
    DNAdYYEncodingTypeStruct     = 19, ///< struct
    DNAdYYEncodingTypeUnion      = 20, ///< union
    DNAdYYEncodingTypeCString    = 21, ///< char*
    DNAdYYEncodingTypeCArray     = 22, ///< char[10] (for example)
    
    DNAdYYEncodingTypeQualifierMask   = 0xFF00,   ///< mask of qualifier
    DNAdYYEncodingTypeQualifierConst  = 1 << 8,  ///< const
    DNAdYYEncodingTypeQualifierIn     = 1 << 9,  ///< in
    DNAdYYEncodingTypeQualifierInout  = 1 << 10, ///< inout
    DNAdYYEncodingTypeQualifierOut    = 1 << 11, ///< out
    DNAdYYEncodingTypeQualifierBycopy = 1 << 12, ///< bycopy
    DNAdYYEncodingTypeQualifierByref  = 1 << 13, ///< byref
    DNAdYYEncodingTypeQualifierOneway = 1 << 14, ///< oneway
    
    DNAdYYEncodingTypePropertyMask         = 0xFF0000, ///< mask of property
    DNAdYYEncodingTypePropertyReadonly     = 1 << 16, ///< readonly
    DNAdYYEncodingTypePropertyCopy         = 1 << 17, ///< copy
    DNAdYYEncodingTypePropertyRetain       = 1 << 18, ///< retain
    DNAdYYEncodingTypePropertyNonatomic    = 1 << 19, ///< nonatomic
    DNAdYYEncodingTypePropertyWeak         = 1 << 20, ///< weak
    DNAdYYEncodingTypePropertyCustomGetter = 1 << 21, ///< getter=
    DNAdYYEncodingTypePropertyCustomSetter = 1 << 22, ///< setter=
    DNAdYYEncodingTypePropertyDynamic      = 1 << 23, ///< @dynamic
};

/**
 Get the type from a Type-Encoding string.
 
 @discussion See also:
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
 
 @param typeEncoding  A Type-Encoding string.
 @return The encoding type.
 */
DNAdYYEncodingType YYEncodingGetType(const char *typeEncoding);


/**
 Instance variable information.
 */
@interface DNAdYYClassIvarInfo : NSObject
@property (nonatomic, assign, readonly) Ivar ivar;              ///< ivar opaque struct
@property (nonatomic, strong, readonly) NSString *name;         ///< Ivar's name
@property (nonatomic, assign, readonly) ptrdiff_t offset;       ///< Ivar's offset
@property (nonatomic, strong, readonly) NSString *typeEncoding; ///< Ivar's type encoding
@property (nonatomic, assign, readonly) DNAdYYEncodingType type;    ///< Ivar's type

/**
 Creates and returns an ivar info object.
 
 @param ivar ivar opaque struct
 @return A new object, or nil if an error occurs.
 */
- (instancetype)initWithIvar:(Ivar)ivar;
@end


/**
 Method information.
 */
@interface DNAdYYClassMethodInfo : NSObject
@property (nonatomic, assign, readonly) Method method;                  ///< method opaque struct
@property (nonatomic, strong, readonly) NSString *name;                 ///< method name
@property (nonatomic, assign, readonly) SEL sel;                        ///< method's selector
@property (nonatomic, assign, readonly) IMP imp;                        ///< method's implementation
@property (nonatomic, strong, readonly) NSString *typeEncoding;         ///< method's parameter and return types
@property (nonatomic, strong, readonly) NSString *returnTypeEncoding;   ///< return value's type
@property (nullable, nonatomic, strong, readonly) NSArray<NSString *> *argumentTypeEncodings; ///< array of arguments' type

/**
 Creates and returns a method info object.
 
 @param method method opaque struct
 @return A new object, or nil if an error occurs.
 */
- (instancetype)initWithMethod:(Method)method;
@end


/**
 Property information.
 */
@interface DNAdYYClassPropertyInfo : NSObject
@property (nonatomic, assign, readonly) objc_property_t property; ///< property's opaque struct
@property (nonatomic, strong, readonly) NSString *name;           ///< property's name
@property (nonatomic, assign, readonly) DNAdYYEncodingType type;      ///< property's type
@property (nonatomic, strong, readonly) NSString *typeEncoding;   ///< property's encoding value
@property (nonatomic, strong, readonly) NSString *ivarName;       ///< property's ivar name
@property (nullable, nonatomic, assign, readonly) Class cls;      ///< may be nil
@property (nullable, nonatomic, strong, readonly) NSArray<NSString *> *protocols; ///< may nil
@property (nonatomic, assign, readonly) SEL getter;               ///< getter (nonnull)
@property (nonatomic, assign, readonly) SEL setter;               ///< setter (nonnull)

/**
 Creates and returns a property info object.
 
 @param property property opaque struct
 @return A new object, or nil if an error occurs.
 */
- (instancetype)initWithProperty:(objc_property_t)property;
@end


/**
 Class information for a class.
 */
@interface DNAdYYClassInfo : NSObject
@property (nonatomic, assign, readonly) Class cls; ///< class object
@property (nullable, nonatomic, assign, readonly) Class superCls; ///< super class object
@property (nullable, nonatomic, assign, readonly) Class metaCls;  ///< class's meta class object
@property (nonatomic, readonly) BOOL isMeta; ///< whether this class is meta class
@property (nonatomic, strong, readonly) NSString *name; ///< class name
@property (nullable, nonatomic, strong, readonly) DNAdYYClassInfo *superClassInfo; ///< super class's class info
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, DNAdYYClassIvarInfo *> *ivarInfos; ///< ivars
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, DNAdYYClassMethodInfo *> *methodInfos; ///< methods
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, DNAdYYClassPropertyInfo *> *propertyInfos; ///< properties

/**
 If the class is changed (for example: you add a method to this class with
 'class_addMethod()'), you should call this method to refresh the class info cache.
 
 After called this method, `needUpdate` will returns `YES`, and you should call 
 'classInfoWithClass' or 'classInfoWithClassName' to get the updated class info.
 */
- (void)setNeedUpdate;

/**
 If this method returns `YES`, you should stop using this instance and call
 `classInfoWithClass` or `classInfoWithClassName` to get the updated class info.
 
 @return Whether this class info need update.
 */
- (BOOL)needUpdate;

/**
 Get the class info of a specified Class.
 
 @discussion This method will cache the class info and super-class info
 at the first access to the Class. This method is thread-safe.
 
 @param cls A class.
 @return A class info, or nil if an error occurs.
 */
+ (nullable instancetype)classInfoWithClass:(Class)cls;

/**
 Get the class info of a specified Class.
 
 @discussion This method will cache the class info and super-class info
 at the first access to the Class. This method is thread-safe.
 
 @param className A class name.
 @return A class info, or nil if an error occurs.
 */
+ (nullable instancetype)classInfoWithClassName:(NSString *)className;

@end

NS_ASSUME_NONNULL_END
