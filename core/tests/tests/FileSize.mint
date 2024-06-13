suite "FileSize.format" {
  test "for 0 return 0B" {
    FileSize.format(0) == "0 B"
  }

  test "for 1000 returns 1kB" {
    FileSize.format(1000) == "1 kB"
  }

  test "for 1000000 returns 1MB" {
    FileSize.format(1000000) == "1 MB"
  }

  test "for 1000000000 returns 1GB" {
    FileSize.format(1000000000) == "1 GB"
  }
}
