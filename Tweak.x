// TinTweak — ukázkový tweak pro LiveContainer
// Co dělá:
//   1) při injektáži zapíše do konzole, do které appky se dostal
//   2) u každé obrazovky zapíše její třídu (mapování appky)
//   3) jednou zobrazí alert — vizuální důkaz, že tweak běží

#import <UIKit/UIKit.h>

// ── 1) Konstruktor tweaku: proběhne ve chvíli, kdy se dylib načte do procesu
%ctor {
    NSString *bundle = [[NSBundle mainBundle] bundleIdentifier] ?: @"neznamy";
    NSLog(@"[TinTweak] nacitam se do appky: %@", bundle);
}

%hook UIViewController

- (void)viewDidAppear:(BOOL)animated {
    %orig;   // necháme appku nejdřív udělat svoji práci

    // ── 2) Logger: každá obrazovka se objeví v konzoli (StikDebug → Console)
    NSLog(@"[TinTweak] obrazovka: %@", NSStringFromClass([self class]));

    // ── 3) Jednorázový viditelný důkaz
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSString *bundle = [[NSBundle mainBundle] bundleIdentifier] ?: @"?";
        UIAlertController *alert = [UIAlertController
            alertControllerWithTitle:@"Tin tweak běží ⚡"
                             message:[NSString stringWithFormat:@"Injektováno do: %@\nPrvní obrazovka: %@",
                                      bundle, NSStringFromClass([self class])]
                      preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

%end
