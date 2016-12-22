//
//  Utils+CGRect.h
//  neemble
//
//  Created by Артем Кулагин on 09.11.15.
//  Copyright © 2015 El-Machine. All rights reserved.
//

#ifndef Utils_CGRect_h
#define Utils_CGRect_h

NS_INLINE void   CGSizeNSLog(CGSize s) { NSLog(@"%f %f ",s.width,s.height);}
NS_INLINE void   CGRectNSLog(CGRect r) { NSLog(@"%f %f %f %f ",r.origin.x,r.origin.y, r.size.width,r.size.height);}
NS_INLINE CGRect CGRectSetX     (CGRect r, CGFloat x     ){ return CGRectMake(         x, r.origin.y, r.size.width, r.size.height);}
NS_INLINE CGRect CGRectSetY     (CGRect r, CGFloat y     ){ return CGRectMake(r.origin.x,          y, r.size.width, r.size.height);}
NS_INLINE CGRect CGRectSetWidth (CGRect r, CGFloat width ){ return CGRectMake(r.origin.x, r.origin.y,        width, r.size.height);}
NS_INLINE CGRect CGRectSetHeight(CGRect r, CGFloat height){ return CGRectMake(r.origin.x, r.origin.y, r.size.width,        height);}
NS_INLINE CGRect CGRectSetSize  (CGRect r, CGSize  size ) { return CGRectMake(r.origin.x, r.origin.y,   size.width,   size.height);}

#endif /* Utils_CGRect_h */


