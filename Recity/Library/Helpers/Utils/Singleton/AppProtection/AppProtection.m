//
//  AppProtection.m
//  TraxMove
//
//  Created by Alexander Kozin on 15.09.15.
//  Copyright © 2015 Siberian.pro. All rights reserved.
//

#import "AppProtection.h"

#import <dlfcn.h>

#pragma mark - Dyne debugger attach

void disable_debugger(void);

typedef int (* ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);
#if !defined(PT_DENY_ATTACH)
#define PT_DENY_ATTACH 31
#endif

void disable_debugger_on_release(void)
{
#ifndef DEBUG
    disable_debugger();
#endif
}

void disable_debugger(void)
{
    void * handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
    ptrace_ptr_t ptrace_ptr = dlsym(handle, "ptrace");
    ptrace_ptr(PT_DENY_ATTACH, 0, 0, 0);
    dlclose(handle);

//    __asm("mov r0, %31"
//          "mov r1, %0"
//          "mov r2, %0"
//          "mov r3, %0"
//          "mov ip, %26"
//          "svc %0x80");
}




