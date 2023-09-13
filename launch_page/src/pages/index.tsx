import { Open_Sans } from "next/font/google";

const openSans = Open_Sans({ subsets: ["latin"] });

export default function Home() {
  return (
    <main
      className={`${openSans.className} text-black flex flex-col items-center h-full relative cool `}
    >
      <div className="background-container">
        <div className="stars"></div>
        <div className="twinkling"></div>
      </div>
      <div className="h-48 w-full bg-transparent"></div>
      <img
        className="w-24 z-10 relative  -bottom-12 drop-shadow-2x"
        src="/app_icon.png"
        alt="Bible Ram Logo"
      />
      <div className="h-full bg-white w-full flex flex-col items-center relative place">
        <div className="h-12"></div>
        <h2 className="font-bold text-3xl">Bible Ram</h2>
        <p className="text-sm text-gray-500 text-center">
          The new app for memorizing scripture
        </p>
        <div className="mt-5 text-center text-sm text-gray-500 underline pb-safe">
          <a href="/privacy-policy">Privacy Policy</a>
          <p>
            <a href="https://github.com/joshpetit/bibleram">Source Code</a>
          </p>
          <p>
            <a href="https://josh.petit.dev" target="_blank">
              More from the developer
            </a>
          </p>
        </div>
        <a href="https://play.google.com/store/apps/details?id=app.bibleram">
          <img
            className="w-60"
            src={"/get_on_google.svg"}
            alt="Get it on Google Play"
          />
        </a>
        <a target="_blank" href="https://apps.apple.com/us/app/bible-ram-memorize-scripture/id6450688436">
          <img
            className="w-60 px-4"
            src={"/apple.png"}
            alt="Get it on the App Store"
          />
        </a>
      </div>
    </main>
  );
}
