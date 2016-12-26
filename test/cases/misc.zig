// normal comment
/// this is a documentation comment
/// doc comment line 2
fn emptyFunctionWithComments() {
    @setFnTest(this);
}

export fn disabledExternFn() {
    @setFnVisible(this, false);
}

fn callDisabledExternFn() {
    @setFnTest(this);

    disabledExternFn();
}

fn intTypeBuiltin() {
    @setFnTest(this);

    assert(@intType(true, 8) == i8);
    assert(@intType(true, 16) == i16);
    assert(@intType(true, 32) == i32);
    assert(@intType(true, 64) == i64);

    assert(@intType(false, 8) == u8);
    assert(@intType(false, 16) == u16);
    assert(@intType(false, 32) == u32);
    assert(@intType(false, 64) == u64);

    assert(i8.bit_count == 8);
    assert(i16.bit_count == 16);
    assert(i32.bit_count == 32);
    assert(i64.bit_count == 64);

    assert(i8.is_signed);
    assert(i16.is_signed);
    assert(i32.is_signed);
    assert(i64.is_signed);
    assert(isize.is_signed);

    assert(!u8.is_signed);
    assert(!u16.is_signed);
    assert(!u32.is_signed);
    assert(!u64.is_signed);
    assert(!usize.is_signed);
}

fn minValueAndMaxValue() {
    @setFnTest(this);

    assert(@maxValue(u8) == 255);
    assert(@maxValue(u16) == 65535);
    assert(@maxValue(u32) == 4294967295);
    assert(@maxValue(u64) == 18446744073709551615);

    assert(@maxValue(i8) == 127);
    assert(@maxValue(i16) == 32767);
    assert(@maxValue(i32) == 2147483647);
    assert(@maxValue(i64) == 9223372036854775807);

    assert(@minValue(u8) == 0);
    assert(@minValue(u16) == 0);
    assert(@minValue(u32) == 0);
    assert(@minValue(u64) == 0);

    assert(@minValue(i8) == -128);
    assert(@minValue(i16) == -32768);
    assert(@minValue(i32) == -2147483648);
    assert(@minValue(i64) == -9223372036854775808);
}

fn maxValueType() {
    @setFnTest(this);

    // If the type of @maxValue(i32) was i32 then this implicit cast to
    // u32 would not work. But since the value is a number literal,
    // it works fine.
    const x: u32 = @maxValue(i32);
    assert(x == 2147483647);
}

fn shortCircuit() {
    @setFnTest(this);

    var hit_1 = false;
    var hit_2 = false;
    var hit_3 = false;
    var hit_4 = false;

    if (true || {assert(false); false}) {
        hit_1 = true;
    }
    if (false || { hit_2 = true; false }) {
        assert(false);
    }

    if (true && { hit_3 = true; false }) {
        assert(false);
    }
    if (false && {assert(false); false}) {
        assert(false);
    } else {
        hit_4 = true;
    }
    assert(hit_1);
    assert(hit_2);
    assert(hit_3);
    assert(hit_4);
}

fn truncate() {
    @setFnTest(this);

    assert(testTruncate(0x10fd) == 0xfd);
}
fn testTruncate(x: u32) -> u8 {
    @truncate(u8, x)
}

fn assignToIfVarPtr() {
    @setFnTest(this);

    var maybe_bool: ?bool = true;

    if (const *b ?= maybe_bool) {
        *b = false;
    }

    assert(??maybe_bool == false);
}

fn first4KeysOfHomeRow() -> []const u8 {
    "aoeu"
}

fn ReturnStringFromFunction() {
    @setFnTest(this);

    assert(memeql(first4KeysOfHomeRow(), "aoeu"));
}

const g1 : i32 = 1233 + 1;
var g2 : i32 = 0;

fn globalVariables() {
    @setFnTest(this);

    assert(g2 == 0);
    g2 = g1;
    assert(g2 == 1234);
}


fn memcpyAndMemsetIntrinsics() {
    @setFnTest(this);

    var foo : [20]u8 = undefined;
    var bar : [20]u8 = undefined;

    @memset(&foo[0], 'A', foo.len);
    @memcpy(&bar[0], &foo[0], bar.len);

    if (bar[11] != 'A') @unreachable();
}

fn builtinStaticEval() {
    @setFnTest(this);

    const x : i32 = @staticEval(1 + 2 + 3);
    assert(x == @staticEval(6));
}

fn slicing() {
    @setFnTest(this);

    var array : [20]i32 = undefined;

    array[5] = 1234;

    var slice = array[5...10];

    if (slice.len != 5) @unreachable();

    const ptr = &slice[0];
    if (ptr[0] != 1234) @unreachable();

    var slice_rest = array[10...];
    if (slice_rest.len != 10) @unreachable();
}


fn constantEqualFunctionPointers() {
    @setFnTest(this);

    const alias = emptyFn;
    assert(@staticEval(emptyFn == alias));
}

fn emptyFn() {}


fn hexEscape() {
    @setFnTest(this);

    assert(memeql("\x68\x65\x6c\x6c\x6f", "hello"));
}

fn stringConcatenation() {
    @setFnTest(this);

    assert(memeql("OK" ++ " IT " ++ "WORKED", "OK IT WORKED"));
}

fn arrayMultOperator() {
    @setFnTest(this);

    assert(memeql("ab" ** 5, "ababababab"));
}

fn stringEscapes() {
    @setFnTest(this);

    assert(memeql("\"", "\x22"));
    assert(memeql("\'", "\x27"));
    assert(memeql("\n", "\x0a"));
    assert(memeql("\r", "\x0d"));
    assert(memeql("\t", "\x09"));
    assert(memeql("\\", "\x5c"));
    assert(memeql("\u1234\u0069", "\xe1\x88\xb4\x69"));
}

fn multilineString() {
    @setFnTest(this);

    const s1 =
        \\one
        \\two)
        \\three
    ;
    const s2 = "one\ntwo)\nthree";
    assert(memeql(s1, s2));
}

fn multilineCString() {
    @setFnTest(this);

    const s1 =
        c\\one
        c\\two)
        c\\three
    ;
    const s2 = c"one\ntwo)\nthree";
    assert(cstrcmp(s1, s2) == 0);
}


fn typeEquality() {
    @setFnTest(this);

    assert(&const u8 != &u8);
}


const global_a: i32 = 1234;
const global_b: &const i32 = &global_a;
const global_c: &const f32 = (&const f32)(global_b);
fn compileTimeGlobalReinterpret() {
    @setFnTest(this);
    const d = (&const i32)(global_c);
    assert(*d == 1234);
}

fn explicitCastMaybePointers() {
    @setFnTest(this);

    const a: ?&i32 = undefined;
    const b: ?&f32 = (?&f32)(a);
}

fn genericMallocFree() {
    @setFnTest(this);

    const a = %%memAlloc(u8, 10);
    memFree(u8, a);
}
const some_mem : [100]u8 = undefined;
fn memAlloc(inline T: type, n: usize) -> %[]T {
    return (&T)(&some_mem[0])[0...n];
}
fn memFree(inline T: type, mem: []T) { }


fn castUndefined() {
    @setFnTest(this);

    const array: [100]u8 = undefined;
    const slice = ([]u8)(array);
    testCastUndefined(slice);
}
fn testCastUndefined(x: []const u8) {}


fn castSmallUnsignedToLargerSigned() {
    @setFnTest(this);

    assert(castSmallUnsignedToLargerSigned1(200) == i16(200));
    assert(castSmallUnsignedToLargerSigned2(9999) == i64(9999));
}
fn castSmallUnsignedToLargerSigned1(x: u8) -> i16 { x }
fn castSmallUnsignedToLargerSigned2(x: u16) -> i64 { x }


fn implicitCastAfterUnreachable() {
    @setFnTest(this);

    assert(outer() == 1234);
}
fn inner() -> i32 { 1234 }
fn outer() -> i64 {
    return inner();
}


fn pointerDereferencing() {
    @setFnTest(this);

    var x = i32(3);
    const y = &x;

    *y += 1;

    assert(x == 4);
    assert(*y == 4);
}

fn callResultOfIfElseExpression() {
    @setFnTest(this);

    assert(memeql(f2(true), "a"));
    assert(memeql(f2(false), "b"));
}
fn f2(x: bool) -> []u8 {
    return (if (x) fA else fB)();
}
fn fA() -> []u8 { "a" }
fn fB() -> []u8 { "b" }


fn constExpressionEvalHandlingOfVariables() {
    @setFnTest(this);

    var x = true;
    while (x) {
        x = false;
    }
}



fn constantEnumInitializationWithDifferingSizes() {
    @setFnTest(this);

    test3_1(test3_foo);
    test3_2(test3_bar);
}
const Test3Foo = enum {
    One,
    Two: f32,
    Three: Test3Point,
};
const Test3Point = struct {
    x: i32,
    y: i32,
};
const test3_foo = Test3Foo.Three{Test3Point {.x = 3, .y = 4}};
const test3_bar = Test3Foo.Two{13};
fn test3_1(f: Test3Foo) {
    switch (f) {
        Test3Foo.Three => |pt| {
            assert(pt.x == 3);
            assert(pt.y == 4);
        },
        else => @unreachable(),
    }
}
fn test3_2(f: Test3Foo) {
    switch (f) {
        Test3Foo.Two => |x| {
            assert(x == 13);
        },
        else => @unreachable(),
    }
}


fn characterLiterals() {
    @setFnTest(this);

    assert('\'' == single_quote);
}
const single_quote = '\'';



fn takeAddressOfParameter() {
    @setFnTest(this);

    testTakeAddressOfParameter(12.34);
}
fn testTakeAddressOfParameter(f: f32) {
    const f_ptr = &f;
    assert(*f_ptr == 12.34);
}


fn intToPtrCast() {
    @setFnTest(this);

    const x = isize(13);
    const y = (&u8)(x);
    const z = usize(y);
    assert(z == 13);
}


fn pointerComparison() {
    @setFnTest(this);

    const a = ([]u8)("a");
    const b = &a;
    assert(ptrEql(b, b));
}
fn ptrEql(a: &[]const u8, b: &[]const u8) -> bool {
    a == b
}


fn cStringConcatenation() {
    @setFnTest(this);

    const a = c"OK" ++ c" IT " ++ c"WORKED";
    const b = c"OK IT WORKED";

    const len = cstrlen(b);
    const len_with_null = len + 1;
    {var i: u32 = 0; while (i < len_with_null; i += 1) {
        assert(a[i] == b[i]);
    }}
    assert(a[len] == 0);
    assert(b[len] == 0);
}

// TODO import from std.cstr
pub fn cstrlen(ptr: &const u8) -> usize {
    var count: usize = 0;
    while (ptr[count] != 0; count += 1) {}
    return count;
}

// TODO import from std.str
pub fn memeql(a: []const u8, b: []const u8) -> bool {
    sliceEql(u8, a, b)
}

// TODO import from std.str
pub fn sliceEql(inline T: type, a: []const T, b: []const T) -> bool {
    if (a.len != b.len) return false;
    for (a) |item, index| {
        if (b[index] != item) return false;
    }
    return true;
}

// TODO import from std.cstr
pub fn cstrcmp(a: &const u8, b: &const u8) -> i8 {
    var index: usize = 0;
    while (a[index] == b[index] && a[index] != 0; index += 1) {}
    return if (a[index] > b[index]) {
        1
    } else if (a[index] < b[index]) {
        -1
    } else {
        i8(0)
    };
}

// TODO const assert = @import("std").debug.assert;
fn assert(ok: bool) {
    if (!ok)
        @unreachable();
}
