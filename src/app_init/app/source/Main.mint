component Main {
  style app {
    justify-content: center;
    flex-direction: column;
    align-items: center;
    display: flex;

    background-color: #282C34;
    height: 100vh;
    width: 100vw;

    font-family: Open Sans;
    font-weight: bold;
  }

  fun render : Html {
    <div::app>
      <Logo/>

      <Info mainPath="source/Main.mint"/>

      <Link href="https://www.mint-lang.com/">
        "Learn Mint"
      </Link>
    </div>
  }
}
