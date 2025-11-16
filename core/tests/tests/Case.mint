type CaseTest {
  A
  B
  C
}

type CaseTest2 {
  A(String)
  B(String)
  C(String)
}

suite "case" {
  fun a : CaseTest {
    CaseTest.A
  }

  fun b : CaseTest {
    CaseTest.B
  }

  fun c : CaseTest {
    CaseTest.C
  }

  fun a2 : CaseTest2 {
    CaseTest2.A("WTF")
  }

  fun b2 : CaseTest2 {
    CaseTest2.B("WTF")
  }

  fun c2 : CaseTest2 {
    CaseTest2.C("WTF")
  }

  test "matches alternative patterns" {
    case a() {
      A | B => true
      C => false
    }
  }

  test "matches alternative patterns #2" {
    case b() {
      A | B => true
      C => false
    }
  }

  test "matches alternative patterns #3" {
    case c() {
      A | B => false
      C => true
    }
  }

  test "matches alternative patterns #4" {
    case a2() {
      A(a) | B(a) | C(a) => a == "WTF"
    }
  }

  test "matches alternative patterns #5" {
    case b2() {
      A(a) | B(a) | C(a) => a == "WTF"
    }
  }

  test "matches alternative patterns #6" {
    case c2() {
      A(a) | B(a) | C(a) => a == "WTF"
    }
  }
}
