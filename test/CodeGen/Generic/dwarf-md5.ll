; MD5 checksums provided by IR should be passed through to asm.
; They'll be emitted to an object file only for DWARF 5 or later.

; Darwin clamps the line table at DWARF v2 so XFAIL this test.
; XFAIL: darwin

; REQUIRES: object-emission
; RUN: %llc_dwarf -dwarf-version 4 -filetype=asm -o - %s | FileCheck %s --check-prefix=ASM
; RUN: %llc_dwarf -dwarf-version 5 -filetype=asm -o - %s | FileCheck %s --check-prefix=ASM
; RUN: %llc_dwarf -dwarf-version 4 -filetype=obj -o %t4.o %s
; RUN: llvm-dwarfdump -debug-line %t4.o | FileCheck %s --check-prefix=OBJ-4
; RUN: %llc_dwarf -dwarf-version 5 -filetype=obj -o %t5.o %s
; RUN: llvm-dwarfdump -debug-line %t5.o | FileCheck %s --check-prefix=OBJ-5

; FIXME: Need to convey the MD5 for the primary source file.
; ASM: .file 1 ".{{/|\\\\}}t1.h" md5 "11111111111111111111111111111111"
; ASM: .file 2 ".{{/|\\\\}}t2.h" md5 "22222222222222222222222222222222"

; OBJ-4: Dir Mod Time File Len File Name
; OBJ-4: file_names[ 1] 1 0x00000000 0x00000000 "t1.h"
; OBJ-4: file_names[ 2] 1 0x00000000 0x00000000 "t2.h"

; OBJ-5: Dir MD5 Checksum File Name
; OBJ-5: file_names[ 1] 1 11111111111111111111111111111111 "t1.h"
; OBJ-5: file_names[ 2] 1 22222222222222222222222222222222 "t2.h"

; ModuleID = 't.c'
source_filename = "t.c"

@t1 = global i32 1, align 4, !dbg !0
@t2 = global i32 0, align 4, !dbg !6

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!11, !12, !13}
!llvm.ident = !{!14}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "t1", scope: !2, file: !10, line: 1, type: !9, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 7.0.0 (trunk 322159)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5)
!3 = !DIFile(filename: "t.c", directory: "/home/probinson/projects/scratch", checksumkind: CSK_MD5, checksum: "00000000000000000000000000000000")
!4 = !{}
!5 = !{!0, !6}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "t2", scope: !2, file: !8, line: 1, type: !9, isLocal: false, isDefinition: true)
!8 = !DIFile(filename: "./t2.h", directory: "/home/probinson/projects/scratch", checksumkind: CSK_MD5, checksum: "22222222222222222222222222222222")
!9 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!10 = !DIFile(filename: "./t1.h", directory: "/home/probinson/projects/scratch", checksumkind: CSK_MD5, checksum: "11111111111111111111111111111111")
!11 = !{i32 2, !"Dwarf Version", i32 4}
!12 = !{i32 2, !"Debug Info Version", i32 3}
!13 = !{i32 1, !"wchar_size", i32 4}
!14 = !{!"clang version 7.0.0 (trunk 322159)"}
