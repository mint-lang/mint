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
  test "matches alternative patterns" {
    case CaseTest.A {
      A | B => true
      C => false
    }
  }

  test "matches alternative patterns #2" {
    case CaseTest.B {
      A | B => true
      C => false
    }
  }

  test "matches alternative patterns #3" {
    case CaseTest.C {
      A | B => false
      C => true
    }
  }

  test "matches alternative patterns #4" {
    case CaseTest2.A("WTF") {
      A(a) | B(a) | C(a) => a == "WTF"
    }
  }

  test "matches alternative patterns #5" {
    case CaseTest2.B("WTF") {
      A(a) | B(a) | C(a) => a == "WTF"
    }
  }

  test "matches alternative patterns #6" {
    case CaseTest2.C("WTF") {
      A(a) | B(a) | C(a) => a == "WTF"
    }
  }
}
