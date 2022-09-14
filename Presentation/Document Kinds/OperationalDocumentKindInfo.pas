unit OperationalDocumentKindInfo;

interface

uses

  UIDocumentKinds,
  DocumentKinds,
  SysUtils;

type

  IOperationalDocumentKindInfo = interface

    function GetGlobalDocumentKindId: Variant;
    procedure SetGlobalDocumentKindId(const Value: Variant);

    function GetWorkingDocumentKindId: Variant;
    procedure SetWorkingDocumentKindId(const Value: Variant);

    function GetServiceDocumentKind: TDocumentKindClass;
    procedure SetServiceDocumentKind(const Value: TDocumentKindClass);

    function GetUIDocumentKind: TUIDocumentKindClass;
    procedure SetUIDocumentKind(const Value: TUIDocumentKindClass);
    
    property GlobalDocumentKindId: Variant
    read GetGlobalDocumentKindId write SetGlobalDocumentKindId;

    property WorkingDocumentKindId: Variant
    read GetWorkingDocumentKindId write SetWorkingDocumentKindId;

    property ServiceDocumentKind: TDocumentKindClass
    read GetServiceDocumentKind write SetServiceDocumentKind;

    property UIDocumentKind: TUIDocumentKindClass
    read GetUIDocumentKind write SetUIDocumentKind;

  end;

  TOperationalDocumentKindInfo = class (TInterfacedObject, IOperationalDocumentKindInfo)

    private

      FGlobalDocumentKindId: Variant;
      FWorkingDocumentKindId: Variant;
      FServiceDocumentKind: TDocumentKindClass;
      FUIDocumentKind: TUIDocumentKindClass;

    public

      destructor Destroy; override;
      
      constructor Create(
        GlobalDocumentKindId: Variant;
        WorkingDocumentKindId: Variant;
        ServiceDocumentKind: TDocumentKindClass;
        UIDocumentKind: TUIDocumentKindClass
      );

    public

      function GetGlobalDocumentKindId: Variant;
      procedure SetGlobalDocumentKindId(const Value: Variant);

      function GetWorkingDocumentKindId: Variant;
      procedure SetWorkingDocumentKindId(const Value: Variant);

      function GetServiceDocumentKind: TDocumentKindClass;
      procedure SetServiceDocumentKind(const Value: TDocumentKindClass);

      function GetUIDocumentKind: TUIDocumentKindClass;
      procedure SetUIDocumentKind(const Value: TUIDocumentKindClass);

    public
    
      property GlobalDocumentKindId: Variant
      read GetGlobalDocumentKindId write SetGlobalDocumentKindId;

      property WorkingDocumentKindId: Variant
      read GetWorkingDocumentKindId write SetWorkingDocumentKindId;

      property ServiceDocumentKind: TDocumentKindClass
      read GetServiceDocumentKind write SetServiceDocumentKind;

      property UIDocumentKind: TUIDocumentKindClass
      read GetUIDocumentKind write SetUIDocumentKind;

  end;

implementation

{ TOperationalDocumentKindInfo }

constructor TOperationalDocumentKindInfo.Create(
  GlobalDocumentKindId: Variant;
  WorkingDocumentKindId: Variant;
  ServiceDocumentKind: TDocumentKindClass;
  UIDocumentKind: TUIDocumentKindClass
);
begin

  Self.GlobalDocumentKindId := GlobalDocumentKindId;
  Self.WorkingDocumentKindId := WorkingDocumentKindId;
  Self.ServiceDocumentKind := ServiceDocumentKind;
  Self.UIDocumentKind := UIDocumentKind;

end;

destructor TOperationalDocumentKindInfo.Destroy;
begin

  inherited;
  
end;

function TOperationalDocumentKindInfo.GetGlobalDocumentKindId: Variant;
begin

  Result := FGlobalDocumentKindId;

end;

function TOperationalDocumentKindInfo.GetServiceDocumentKind: TDocumentKindClass;
begin

  Result := FServiceDocumentKind;

end;

function TOperationalDocumentKindInfo.GetUIDocumentKind: TUIDocumentKindClass;
begin

  Result := FUIDocumentKind;

end;

function TOperationalDocumentKindInfo.GetWorkingDocumentKindId: Variant;
begin

  Result := FWorkingDocumentKindId;

end;

procedure TOperationalDocumentKindInfo.SetGlobalDocumentKindId(
  const Value: Variant);
begin

  FGlobalDocumentKindId := Value;

end;

procedure TOperationalDocumentKindInfo.SetServiceDocumentKind(
  const Value: TDocumentKindClass);
begin

  FServiceDocumentKind := Value;

end;

procedure TOperationalDocumentKindInfo.SetUIDocumentKind(
  const Value: TUIDocumentKindClass);
begin

  FUIDocumentKind := Value;
  
end;

procedure TOperationalDocumentKindInfo.SetWorkingDocumentKindId(
  const Value: Variant);
begin

  FWorkingDocumentKindId := Value;

end;

end.
