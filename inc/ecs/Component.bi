#ifndef _FB_ECS_COMPONENT_BI__
#define _FB_ECS_COMPONENT_BI__ 1

type Component extends Object
    public:
        cname as string
        _requires(10) as string
        declare function create(byref cname as const string) as Component ptr

end type

#endif