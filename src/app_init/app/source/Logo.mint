component Logo {
  style logo {
    svg {
      animation: shake 2s infinite ease-in-out;
      animation-delay: 1s;
    }

    @keyframes shake {
      0% {
        transform: translate(1px, 1px) rotate(0deg);
      }

      3% {
        transform: translate(-1px, -2px) rotate(-1deg);
      }

      6% {
        transform: translate(-3px, 0px) rotate(1deg);
      }

      9% {
        transform: translate(3px, 2px) rotate(0deg);
      }

      12% {
        transform: translate(1px, -1px) rotate(1deg);
      }

      15% {
        transform: translate(0px, 0px) rotate(-1deg);
      }
    }
  }

  fun render : Html {
    <div::logo>
      <{ @svg(logo.svg) }>
    </div>
  }
}
