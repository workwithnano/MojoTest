# MojoTest

## Building the app

- Targets: iOS 16, Swift 5
- Xcode 14 (Verified it opens and runs using Xcode 14.0.1 on a brand new install)
- Optimized for phone sizes, but runs per the design on iPad (super-stretched!)

1. Open `MojoTest.xcodeproj` in Xcode
2. Select your target device (pick a simulator, otherwise you'll need to set up your own provisioning profile in your own dev account)
3. Run!

> NOTE: If, like me, you've deleted/re-downloaded/re-opened the take-home test zip file, you may get an Xcode error about the swift package not being able to update. To fix, `File > Packages > Reset Package Caches`, then try Running again.

## Fun stuff

- I tried to make sure everything would work with system appearance changes (Dark/Light mode) as well as Dynamic Type. Try it out with a 􀆔+􀆝+A (Dark/Light toggle) or a 􀆔+􀆕+[Plus or Minus] (increase/decrease dynamic type preference)
- Almost everything is SwiftUI. I had to jump out of SwiftUI to adjust `UINavigationBarAppearance`, take advantage of `UIFont` for our custom fonts, and that's about it.
- Charts are also SwiftUI. Of course, they also required that I target iOS 16… the joys of knowing your target audience has the latest version of Xcode installed. You have Xcode 14, right?

## Open Questions

### Design

- Where are the monospaced fonts used? Doesn't look like they're used anywhere
- What are the anchors/constraints for the chart and date-range buttons? They look anchored to the bottom but that's weird inside the scrollView when there's clearly a "Trade" button outside the scrollView truly anchored to the bottom of the screen (used the actual Mojo app for reference)
- There's a row separator below "Long" header, but not below "Short" header
- I wanted to set up code to handle the layout centrally so as to avoid hacks/tweaks to margins, but found it difficult without any guidance in the design 😅

### API

- I had to make a few assumptions on how to de-flatten the API results. For example, I presumed that I could merge the `stockPriceHistoryChange` in the root into the Tom Brady `stock` in the root, which itself should be merged with the Tom Brady `stock` inside the first `position` object.
- Without any unique identifiers for objects returned by the API, I had to wing it :-)
- Good thing I didn't write any API tests yet, because they would have been pissed when I asked them to confirm that the `totalPortfolioGainDollarsFormatted` and `totalPortfolioGainPercentageFormatted` at least shared the same sign. `$46.15` > `-0.51%`. Similarly, the math doesn't always add up, for example the number of shares of Tom Brady owned × the current price of Tom Brady Shares != the `currentValueFormatted` returned for the Tom Brady position.

### The test itself

- I have no idea how you'll evaluate me based on "Stock market features" since I didn't implement trading or anything far beyond displaying prices and such, but I'm looking forward to finding out!

## To-dos

- Check if we're caching remote images properly (running in simulator seems like it re-downloads the headshots every time I open the view)
- This is a financial app, it may be worth it to track prices using Integers so that we don't end up with floating-point rounding errors with fractions of a dollar or fractions of shares
- Increase number of Unit Tests
- Add UI tests
- Accessibility/VoiceOver labeling and testing
- Performance testing. Sometimes load times in the simulator seem unreasonably long, but that may just be debugger-attaching or something dev-related.
  - There are also some inefficiencies in the view hierarchy, I think some wrappers get created behind the scenes that are not necessary, and sometimes it seems like `@State` properties are causing unnecessary refreshes of data which might then trigger loops to run again. On an array of 30 price history json objects, not a big deal. If we ever had a massive chart that had to seek or do some massive O(n^2) lookup or something, we wouldn't want those forced refreshes happening multiple times per view load.
- Make the charts scrubbable for detailed price info.

### Refactors

- Date formatting, get out of the fetch+parse function
- Lots of padding/margin tweaks littered in views need to standardize and add to `AppStyles.swift`
