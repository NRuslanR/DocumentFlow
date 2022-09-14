unit UserInterfaceSwitch;

interface

type

  TUserInterfaceKind = (uiOld, uiNew, uiUnknown);

  IUserInterfaceSwitch = interface

    function GetUserInterfaceKind: TUserInterfaceKind;
    procedure SetUserInterfaceKind(Value: TUserInterfaceKind);
    
    property UserInterfaceKind: TUserInterfaceKind
    read GetUserInterfaceKind write SetUserInterfaceKind;
    
  end;

implementation

end.
