## Accento

For any language learner, figuring out how to effectively type in a target script is not only a learning and mental challenge, but also a needless technical one. Considering the set of languages that use a latin alphabet based script, language learners face a frustruating set of options to try to figure out how to actually type, especially on desktop (we will consider mobile as separate because of UX differences and modal differences).

In the simple case, consider an English native who is learning French. At a minimum, the learner needs to type all necessary combinations of the grave accent (à, è, ì, ò, ù), the acute accent (á, é, í, ó, ú), the diaeresis (ë, ï, ü, and even ÿ), the circumflex (â, ê, î, ô, û) along with the c with cedilla (ç). Additionally, full coverage would include two ligatures (æ, œ), and additional punctuation («, », ‹, ›), and to be pedantic, a thin space (yes narrower than a plain old space) is used between the punctuation and the text before it.

There's a lot of layers there, and probably a custom space width is a bit much for a language learner to worry about when doing a Duolingo exercise, but the solutions available are surprising in that they mostly fail in some obvious, glaring way.

Let's consider them one by one.

1. Add an actual French keyboard layout to your system.
This should basically cover everything we need, but from the user perspective the learning curve is as high as can be. The typical French keyboard layout is an AZERTY layout and not QWERTY. QWERTY ones are available, but the issue then becomes that all those new keys are totally invisible to you. Your keyboard stickers are still the same, and what's more is that now all sorts of punctuation and symbols have been moved around. So there's quite a bit of friction here.

2. Use different character selection mechanisms.
Maybe you are familiar with those Alt codes on Windows. If you want to type some character hold Alt along with 3/4 magical digits in the numpad and insert a character. Or use your system's character picker which has thousands of options. Or create your own compose options (on Mac or Linux) Well, all of these options either require a lot of memorization, are not fluid, or take a long time and effort on the users part.

3. Quick Accent Functionality
This is similar to a phone UI where long pressing a key brings up a set of related characters to type. This addresses a lot of the issues from (2) but is a bit slow. The interface naturally has some delay built in before bringing up the character selection menu, so it can be a slower touch typing experience.

4. Use a layout like US International Dead Key (or Eurkey).
These are decent solutions, and work well for the example we gave (where the user is interested mostly in diacritics). Eurkey's Alt layer is way overpacked for little benefit I feel (since dead keys do much of the same), but in either case, it is productive enough to allow for the French use case using it's dead keys. The typical windows international dead key layout is basically good enough, although it does not allow for typing a capital ÿ nor does it have a œ ligature (I suppose that the æ is for nordic languages), and there are no single guillemets.

Okay so for our hypothetical learner, the last layouts basically get the job done. If you have advanced French typing needs you either need to move to Eurkey or improve on the US International Dead Key layout. However, let's quickly look at other learners for German, Catalan, Romanian, or Polish. Things seem like they should be okay here too, but again US international is missing a key for capital ß, the interpunct for Catalan l·l. Both US international and Eurkey are missing the Romanian the comma below diacritic of ș and ț, and Polish's ogonek on ą and ę are missing. Frusturatingly Eurkey does not even specify what languages it fully supports.

This may all seem esoteric and pedantic, and it surely is, but for keyboard layouts, it's the type of thing that needs to be designed well once for the use case, and then everybody can enjoy it and stop thinking about it.

## What's Offered Here

With the lengthy prologue out of the way, now is the time to introduce this project. This project offers a set of keyboard layouts that attempt to resolve these issues. The general idea is that you have a base keyboard layout (US English but could be others in the future), and a set of characters for a language you want to be able to add to this layout. The following properties will be kept. Keyboards will be offered for both language groups (western romance) and individual languages (Spanish, French, Polish, etc). The following principles are followed:

1. Clarity: The set of languages that each keyboard supports will clearly stated.
2. Completeness: If a keyboard supports a language, all possible characters needed for that ortography, including punctuation, will be included in the layout.
3. Consistency: For specific languages, they will be a subset of the language group they are in. So the Spanish keyboard layout is just a smaller set of characters than the full western romance layout, but in both layouts, ñ, á, é, í, ó, ú, ¡, ¿, etc. are typed the same. Additionally, there will be a reasonable attempt for consistency across language groups, so that users of multiple layouts can more seamlessly move between them.
4. Correlation: The diacritic or supplemental uses of each key should follow visual correlations. For example, the cedilla or comma below diacritic should not be produced by the Shift-4 (the dollar sign). This is easier said than done for some languages and in early testing some compromises have to be made (for example taking into account relative letter frequency).
5. Constrained: Only those characters specific to the language being written are added. No superfluous symbols are added such as ½, ©, etc. There is certainly a use case for these, but there are many more interesting symbols than there are keyboard keys, and any set I would select is unlikely to overlap well with an actual user's use case. There are other solutions out there such as PowerToys Quick Accent, or compose keys which would probably work better for a specific use case.

## Getting the Keyboard

The keyboards are offered as a KLC file which allows for installation on windows. You must also have [MSKLC](https://www.microsoft.com/en-us/download/details.aspx?id=102134), (Microsoft Keyboard Layout Creator) installed on your system. To install the keyboard do the following.

1. Download the KLC locally.
2. Open MSKLC and from `File > Load Source File`, open the KLC.
3. Optionally do `Project > Test Keyboard Layout...`, to see if you like the keyboard before installing it.
4. To install, do `Project > Build DLL and Setup Package`. The keyboards trigger a warning from MSKLC because of using Unicode characters outside the keyboard codepage. So note that non-Unicode aware applications (in general would be older software), diacritic charaters will display as garbled text.
5. Choose to open the directory where the package was built (would be within the `Current Working Directory` listed at the bottom of MSKLC).
6. Run setup.exe from this location which will install the appropriate MSI for your computer's architecture.
7. Now that the keyboard is installed, go to settings to add it as a keyboard option via `Time and Language > Language & Region > Preferred Languages > (Find your system language and click three dots on the right) > Language Options > Installed Keyboards > Add a Keyboard`.
8. To uninstall the keyboard, uninstall as any other program from Control Panel or Settings.

## Find Your Keyboard

From this repo, find the language set you want, and select the base layout you want it on (only US-English is supported for now). Within each folder is the klc definition and a plain text description of where each additional character is mapped to. The language codes are as follows:

* ca: Catalan
* eo: Esperanto
* fr: French
* it: Italian
* oc: Occitan
* pt: Portuguese
* es: Spanish

Language groupings are as follows:

* wro: Western Romance which includes Catalan, French, Italian, Occitan, Portuguese, Spanish.