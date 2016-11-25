#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreServices/CoreServices.h>
#import <QuickLook/QuickLook.h>

static void attach(CFBundleRef* bundle, NSMutableDictionary* attachments, NSString* type, NSString* fileName)
{
    CFURLRef attachURL = CFBundleCopyResourceURL(*bundle, (__bridge CFStringRef)(fileName), NULL, NULL);
    NSData *data = [NSData dataWithContentsOfURL:(__bridge NSURL *)attachURL];
    NSDictionary* attachment = [NSMutableDictionary dictionaryWithObjectsAndKeys:type, (NSString *)kQLPreviewPropertyMIMETypeKey, data, (NSString *)kQLPreviewPropertyAttachmentDataKey, nil];
    [attachments setObject:attachment forKey:fileName];
}

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options)
{
    
    NSMutableString *html;
    
    @autoreleasepool {

        // Load the data
        NSURL *nsurl = (__bridge NSURL *)url;

        NSString *geoDataString = [NSString stringWithContentsOfURL:nsurl encoding:NSUTF8StringEncoding error:nil];

        // Bundle reference
        CFBundleRef bundle = QLPreviewRequestGetGeneratorBundle(preview);

        // Get the template.html file
        CFURLRef templateURL = CFBundleCopyResourceURL(bundle, (CFStringRef)@"template", (CFStringRef)@"html", NULL);
        if (!templateURL) return noErr;
        CFStringRef templatePath = CFURLCopyFileSystemPath(templateURL, kCFURLPOSIXPathStyle);
        if (!templatePath) return noErr;
        NSError *error;
        NSString *document = [[NSString alloc]
                              initWithContentsOfFile:(__bridge NSString*)templatePath
                              encoding:NSUTF8StringEncoding
                              error:&error];

        // Properties
        NSMutableDictionary* properties = [NSMutableDictionary dictionary];
        [properties setObject:@"UTF-8" forKey:(NSString*)kQLPreviewPropertyTextEncodingNameKey];
        [properties setObject:@"text/html" forKey:(NSString*)kQLPreviewPropertyMIMETypeKey];
        
        // Add the attachments
        NSMutableDictionary* attachments = [NSMutableDictionary dictionary];
        attach(&bundle, attachments, @"text/css", @"ol.css");
        attach(&bundle, attachments, @"text/javascript", @"ol.js");
        [properties setObject:attachments forKey:(NSString*)kQLPreviewPropertyAttachmentsKey];
        
        // Create the HTML Document
        html = [[NSMutableString alloc] init];
        // Replace the template {{GEODATASTRING}} with the data.
        [html appendString:[document stringByReplacingOccurrencesOfString:@"{{GEODATASTRING}}" withString:geoDataString]];
        
        QLPreviewRequestSetDataRepresentation(preview,
                                              (__bridge CFDataRef)[html dataUsingEncoding:NSUTF8StringEncoding],
                                              kUTTypeHTML,
                                              (__bridge CFDictionaryRef)properties);
        
        return noErr;
    }
}


void CancelPreviewGeneration(void* thisInterface, QLPreviewRequestRef preview);

void CancelPreviewGeneration(void* thisInterface, QLPreviewRequestRef preview)
{
    // implement only if supported
}
