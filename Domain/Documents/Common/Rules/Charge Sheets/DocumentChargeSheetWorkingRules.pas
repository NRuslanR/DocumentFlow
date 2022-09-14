unit DocumentChargeSheetWorkingRules;

interface

uses

  IGetSelfUnit,
  DocumentChargeSheetWorkingRule,
  DocumentChargeSheetChangingRule,
  DocumentChargeSheetRemovingRule,
  DocumentChargeSheetViewingRule,
  DocumentChargeSheetOverlappedPerformingRule,
  SysUtils,
  Classes;

type

  IDocumentChargeSheetWorkingRules = interface (IGetSelf)

    function GetDocumentChargeSheetViewingRule: IDocumentChargeSheetViewingRule;
    procedure SetDocumentChargeSheetViewingRule(Value: IDocumentChargeSheetViewingRule);

    function GetDocumentChargeSheetChangingRule: IDocumentChargeSheetChangingRule;
    procedure SetDocumentChargeSheetChangingRule(Value: IDocumentChargeSheetChangingRule);

    function GetDocumentChargeSheetRemovingRule: IDocumentChargeSheetRemovingRule;
    procedure SetDocumentChargeSheetRemovingRule(Value: IDocumentChargeSheetRemovingRule);
    
    function GetDocumentChargeSheetPerformingRule: IDocumentChargeSheetWorkingRule;
    procedure SetDocumentChargeSheetPerformingRule(Value: IDocumentChargeSheetWorkingRule);

    function GetDocumentChargeSheetOverlappedPerformingRule: IDocumentChargeSheetOverlappedPerformingRule;
    procedure SetDocumentChargeSheetOverlappedPerformingRule(Value: IDocumentChargeSheetOverlappedPerformingRule);
    
    property DocumentChargeSheetViewingRule: IDocumentChargeSheetViewingRule
    read GetDocumentChargeSheetViewingRule write SetDocumentChargeSheetViewingRule;
        
    property DocumentChargeSheetChangingRule: IDocumentChargeSheetChangingRule
    read GetDocumentChargeSheetChangingRule write SetDocumentChargeSheetChangingRule;

    property DocumentChargeSheetRemovingRule: IDocumentChargeSheetRemovingRule
    read GetDocumentChargeSheetRemovingRule write SetDocumentChargeSheetRemovingRule;
    
    property DocumentChargeSheetPerformingRule: IDocumentChargeSheetWorkingRule
    read GetDocumentChargeSheetPerformingRule write SetDocumentChargeSheetPerformingRule;

    property DocumentChargeSheetOverlappedPerformingRule: IDocumentChargeSheetOverlappedPerformingRule
    read GetDocumentChargeSheetOverlappedPerformingRule write SetDocumentChargeSheetOverlappedPerformingRule;

  end;

  TDocumentChargeSheetWorkingRules =
    class (TInterfacedObject, IDocumentChargeSheetWorkingRules)

      private

        FDocumentChargeSheetViewingRule:
          IDocumentChargeSheetViewingRule;

        FDocumentChargeSheetChangingRule:
          IDocumentChargeSheetChangingRule;

        FDocumentChargeSheetRemovingRule:
          IDocumentChargeSheetRemovingRule;

        FDocumentChargeSheetPerformingRule:
          IDocumentChargeSheetWorkingRule;

        FDocumentChargeSheetOverlappedPerformingRule:
          IDocumentChargeSheetOverlappedPerformingRule;

      public

        function GetDocumentChargeSheetViewingRule: IDocumentChargeSheetViewingRule;
        procedure SetDocumentChargeSheetViewingRule(Value: IDocumentChargeSheetViewingRule);

        function GetDocumentChargeSheetChangingRule: IDocumentChargeSheetChangingRule;
        procedure SetDocumentChargeSheetChangingRule(Value: IDocumentChargeSheetChangingRule);

        function GetDocumentChargeSheetRemovingRule: IDocumentChargeSheetRemovingRule;
        procedure SetDocumentChargeSheetRemovingRule(Value: IDocumentChargeSheetRemovingRule);
    
        function GetDocumentChargeSheetPerformingRule: IDocumentChargeSheetWorkingRule;
        procedure SetDocumentChargeSheetPerformingRule(Value: IDocumentChargeSheetWorkingRule);

        function GetDocumentChargeSheetOverlappedPerformingRule: IDocumentChargeSheetOverlappedPerformingRule;
        procedure SetDocumentChargeSheetOverlappedPerformingRule(Value: IDocumentChargeSheetOverlappedPerformingRule);

      public

        constructor Create; overload;
        constructor Create(

          DocumentChargeSheetViewingRule:
            IDocumentChargeSheetViewingRule;
          
          DocumentChargeSheetChangingRule:
            IDocumentChargeSheetChangingRule;

          DocumentChargeSheetRemovingRule:
            IDocumentChargeSheetRemovingRule;

          DocumentChargeSheetPerformingRule:
            IDocumentChargeSheetWorkingRule;

          DocumentChargeSheetOverlappedPerformingRule:
            IDocumentChargeSheetOverlappedPerformingRule

        ); overload;

        function GetSelf: TObject;

        property DocumentChargeSheetViewingRule: IDocumentChargeSheetViewingRule
        read GetDocumentChargeSheetViewingRule
        write SetDocumentChargeSheetViewingRule;
        
        property DocumentChargeSheetChangingRule: IDocumentChargeSheetChangingRule
        read GetDocumentChargeSheetChangingRule
        write SetDocumentChargeSheetChangingRule;

        property DocumentChargeSheetRemovingRule: IDocumentChargeSheetRemovingRule
        read GetDocumentChargeSheetRemovingRule
        write SetDocumentChargeSheetRemovingRule;
        
        property DocumentChargeSheetPerformingRule: IDocumentChargeSheetWorkingRule
        read GetDocumentChargeSheetPerformingRule
        write SetDocumentChargeSheetPerformingRule;

        property DocumentChargeSheetOverlappedPerformingRule: IDocumentChargeSheetOverlappedPerformingRule
        read GetDocumentChargeSheetOverlappedPerformingRule
        write SetDocumentChargeSheetOverlappedPerformingRule;

    end;

implementation

{ TDocumentChargeSheetWorkingRules }

constructor TDocumentChargeSheetWorkingRules.Create(

  DocumentChargeSheetViewingRule:
    IDocumentChargeSheetViewingRule;
    
  DocumentChargeSheetChangingRule:
    IDocumentChargeSheetChangingRule;

  DocumentChargeSheetRemovingRule:
    IDocumentChargeSheetRemovingRule;

  DocumentChargeSheetPerformingRule:
    IDocumentChargeSheetWorkingRule;

  DocumentChargeSheetOverlappedPerformingRule:
    IDocumentChargeSheetOverlappedPerformingRule
    
);
begin

  inherited Create;

  FDocumentChargeSheetViewingRule := DocumentChargeSheetViewingRule;
  FDocumentChargeSheetChangingRule := DocumentChargeSheetChangingRule;
  FDocumentChargeSheetRemovingRule := DocumentChargeSheetRemovingRule;
  FDocumentChargeSheetPerformingRule := DocumentChargeSheetPerformingRule;

  FDocumentChargeSheetOverlappedPerformingRule :=
    DocumentChargeSheetOverlappedPerformingRule;
    
end;

function TDocumentChargeSheetWorkingRules.
  GetDocumentChargeSheetChangingRule: IDocumentChargeSheetChangingRule;
begin

  Result := FDocumentChargeSheetChangingRule;

end;

function TDocumentChargeSheetWorkingRules.
  GetDocumentChargeSheetOverlappedPerformingRule: IDocumentChargeSheetOverlappedPerformingRule;
begin

  Result := FDocumentChargeSheetOverlappedPerformingRule;
  
end;

function TDocumentChargeSheetWorkingRules.
  GetDocumentChargeSheetPerformingRule: IDocumentChargeSheetWorkingRule;
begin

  Result := FDocumentChargeSheetPerformingRule;
  
end;

function TDocumentChargeSheetWorkingRules.GetDocumentChargeSheetRemovingRule: IDocumentChargeSheetRemovingRule;
begin

  Result := FDocumentChargeSheetRemovingRule;

end;

function TDocumentChargeSheetWorkingRules.
  GetDocumentChargeSheetViewingRule: IDocumentChargeSheetViewingRule;
begin

  Result := FDocumentChargeSheetViewingRule;

end;

function TDocumentChargeSheetWorkingRules.GetSelf: TObject;
begin

  Result := Self;
  
end;

procedure TDocumentChargeSheetWorkingRules.SetDocumentChargeSheetChangingRule(
  Value: IDocumentChargeSheetChangingRule);
begin

  FDocumentChargeSheetChangingRule := Value;
  
end;

procedure TDocumentChargeSheetWorkingRules.SetDocumentChargeSheetOverlappedPerformingRule(
  Value: IDocumentChargeSheetOverlappedPerformingRule);
begin

  FDocumentChargeSheetOverlappedPerformingRule := Value;

end;

procedure TDocumentChargeSheetWorkingRules.SetDocumentChargeSheetPerformingRule(
  Value: IDocumentChargeSheetWorkingRule);
begin

  FDocumentChargeSheetPerformingRule := Value;
  
end;

procedure TDocumentChargeSheetWorkingRules.SetDocumentChargeSheetRemovingRule(
  Value: IDocumentChargeSheetRemovingRule);
begin

  FDocumentChargeSheetRemovingRule := Value;
  
end;

procedure TDocumentChargeSheetWorkingRules.SetDocumentChargeSheetViewingRule(
  Value: IDocumentChargeSheetViewingRule);
begin

  FDocumentChargeSheetViewingRule := Value;

end;

constructor TDocumentChargeSheetWorkingRules.Create;
begin

  inherited;
  
end;

end.
