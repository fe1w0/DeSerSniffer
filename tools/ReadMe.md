>主要我自己都混乱，需要进行修改
# Doop - Modified

## 入口点


souffle-logic/addons/open-programs/entry-points.dl
```
ClassHasPossibleOpenProgramEntryPoint(?class),
PossibleOpenProgramEntryPoint(?method) :-
  Method_DeclaringType(?method, ?class),
  Method_Modifier("public", ?method),
  // 修改
  
    ApplicationClass(?class),
    DefineEntryPointSimpleMethod(?simpleMethodName),
    Method_SimpleName(?method, simpleMethodName),
  
  !Method_Modifier("abstract", ?method),
//// Remove comment for original behavior
//   !Method_Modifier("static", ?method),
  !ClassModifier("private", ?class).
```

## 反射



## 污点分析

注释
```
// TaintSourceMethod("default", "<java.io.BufferedReader: java.lang.String readLine()>").
// TaintSourceMethod("default", "<java.io.BufferedReader: int read(char[],int,int)>").
// // The latter is not a great taint source (since it returns ints) but it's good for minimal testing

// LeakingSinkMethodArg("default", 0, "<java.io.PrintWriter: void println(java.lang.String)>").
```