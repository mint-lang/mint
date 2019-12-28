suite "FileSize.format" {
  test "for 0 return 0B" {
    FileSize.format(0) == "0 B"
  }

  test "for 1024 returns 1kB" {
    FileSize.format(1024) == "1 kB"
  }

  test "for 1048576 returns 1MB" {
    FileSize.format(1048576) == "1 MB"
  }

  test "for 1073741824 returns 1GB" {
    FileSize.format(1073741824) == "1 GB"
  }
}
