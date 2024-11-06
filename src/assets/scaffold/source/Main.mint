// This is the component which gets rendered on the screen
component Main {
  // Styles for the root element.
  style root {
    background-image: url(#{@asset(../assets/bottom-left.png)}),
                      url(#{@asset(../assets/bottom-center.png)}),
                      url(#{@asset(../assets/bottom-right.png)}),
                      url(#{@asset(../assets/top-left.png)}),
                      url(#{@asset(../assets/top-center.png)}),
                      url(#{@asset(../assets/top-right.png)});

    background-position: calc(100% + 15px) 100%, 50% 100%, -20px 100%,
                         -20px 0, 50% 0, calc(100% + 15px) 0;

    background-repeat: no-repeat;
    background-color: white;

    box-sizing: border-box;
    min-height: 100vh;
    padding: 100px;
    display: grid;
    width: 100vw;

    font-family: Noto Sans, sans;
    background-color: #FFF;
    color: #333;

    @media (max-width: 600px) {
      padding: 10px;
    }
  }

  // Styles for the content.
  style content {
    justify-content: center;
    flex-direction: column;
    align-items: center;
    display: flex;

    @media (max-width: 600px) {
      background: rgba(255, 255, 255, 0.5);
      backdrop-filter: blur(3px);

      justify-content: space-between;
      padding: 20px;
    }
  }

  // Styles for the footer.
  style footer {
    border-top: 3px double rgba(0,0,0,0.1);
    padding-top: 30px;
    margin-top: 30px;
    max-width: 72ch;
    width: 100%;

    text-align: center;
    font-size: 20px;

    small {
      margin-top: 5px;
      font-size: 14px;
      display: block;
      opacity: 0.75;
    }
  }

  // Renders the component.
  fun render : Html {
    <div::root>
      <div::content>
        <Content/>

        <div::footer>
          @svg(../assets/logo.svg)
          <small>"2018 - #{Time.year(Time.now())}"</small>
        </div>
      </div>
    </div>
  }
}
