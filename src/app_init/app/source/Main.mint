component Main {
  style app {
    display: flex;
    height: 100vh;
    width: 100vw;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    background-color: #282c34;
    font-weight: bold;
    font-family: Open Sans;
  }

  fun render : Html {
    <div::app>
      <Logo />
      <Info mainpath="source/Main.mint" />
      <Link href="https://www.mint-lang.com/">"Learn Mint"</Link>
    </div>
  }
}
