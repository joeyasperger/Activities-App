//Thanks Wil
//http://wilshipley.com/blog/2005/10/pimp-my-code-interlude-free-code.html

static inline BOOL IsEmpty(id thing) {
    return thing == nil
    || ([thing isEqual:[NSNull null]]) //SB addition for things like coredata
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}

//Modified from Aaron hillegass's code
//http://bignerdranch.com
#define LogMethod() SBLog(@"-[%@ %s]", self, _cmd)
#define WarnMethod() SBWarn(@"-[%@ %s]", self, _cmd)
#define SBWarn NSLog

#ifdef DEBUG
#define SBLog NSLog
#else
#define SBLog    
#endif