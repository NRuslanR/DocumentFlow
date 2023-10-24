unit DocumentFlowInformationFramePropertiesStorage;

interface

uses

  unDocumentFlowInformationFrame,
  DefaultObjectPropertiesStorage,
  IObjectPropertiesStorageUnit,
  UserInterfaceSwitch,
  SysUtils;

type

  IDocumentFlowInformationFramePropertiesStorage = interface
    ['{EE6D4D56-AA69-4B1A-8AF5-ED626D17D42A}']
    procedure RestoreFramePropertiesForUserInterfaceKind(
      Frame: TDocumentFlowInformationFrame;
      UserInterfaceKind: TUserInterfaceKind
    );

    procedure SaveFramePropertiesForUserInterfaceKind(
      Frame: TDocumentFlowInformationFrame;
      UserInterfaceKind: TUserInterfaceKind
    );
      
  end;

implementation

end.
