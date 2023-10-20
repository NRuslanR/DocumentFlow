unit DocumentChargeSheetWorkingRules;

interface

uses

  IGetSelfUnit,
  DocumentChargeSheetWorkingRule,
  DocumentChargeSheetChangingRule,
  DocumentChargeSheetRemovingRule,
  DocumentChargeSheetViewingRule,
  DocumentChargeSheetPerformingRule,
  DocumentChargeSheetIssuingRule,
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
    
    function GetDocumentChargeSheetPerformingRule: IDocumentChargeSheetPerformingRule;
    procedure SetDocumentChargeSheetPerformingRule(Value: IDocumentChargeSheetPerformingRule);

    function GetDocumentChargeSheetOverlappedPerformingRule: IDocumentChargeSheetOverlappedPerformingRule;
    procedure SetDocumentChargeSheetOverlappedPerformingRule(Value: IDocumentChargeSheetOverlappedPerformingRule);

    function GetDocumentChargeSheetIssuingRule: IDocumentChargeSheetIssuingRule;
    procedure SetDocumentChargeSheetIssuingRule(Value: IDocumentChargeSheetIssuingRule);
    
    property DocumentChargeSheetViewingRule: IDocumentChargeSheetViewingRule
    read GetDocumentChargeSheetViewingRule write SetDocumentChargeSheetViewingRule;
        
    property DocumentChargeSheetChangingRule: IDocumentChargeSheetChangingRule
    read GetDocumentChargeSheetChangingRule write SetDocumentChargeSheetChangingRule;

    property DocumentChargeSheetRemovingRule: IDocumentChargeSheetRemovingRule
    read GetDocumentChargeSheetRemovingRule write SetDocumentChargeSheetRemovingRule;
    
    property DocumentChargeSheetPerformingRule: IDocumentChargeSheetPerformingRule
    read GetDocumentChargeSheetPerformingRule write SetDocumentChargeSheetPerformingRule;

    property DocumentChargeSheetOverlappedPerformingRule: IDocumentChargeSheetOverlappedPerformingRule
    read GetDocumentChargeSheetOverlappedPerformingRule write SetDocumentChargeSheetOverlappedPerformingRule;

    property DocumentChargeSheetIssuingRule: IDocumentChargeSheetIssuingRule
    read GetDocumentChargeSheetIssuingRule write SetDocumentChargeSheetIssuingRule;
    
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
          IDocumentChargeSheetPerformingRule;

        FDocumentChargeSheetOverlappedPerformingRule:
          IDocumentChargeSheetOverlappedPerformingRule;

        FDocumentChargeSheetIssuingRule:
          IDocumentChargeSheetIssuingRule;

      public

        function GetDocumentChargeSheetViewingRule: IDocumentChargeSheetViewingRule;
        procedure SetDocumentChargeSheetViewingRule(Value: IDocumentChargeSheetViewingRule);

        function GetDocumentChargeSheetChangingRule: IDocumentChargeSheetChangingRule;
        procedure SetDocumentChargeSheetChangingRule(Value: IDocumentChargeSheetChangingRule);

        function GetDocumentChargeSheetRemovingRule: IDocumentChargeSheetRemovingRule;
        procedure SetDocumentChargeSheetRemovingRule(Value: IDocumentChargeSheetRemovingRule);
    
        function GetDocumentChargeSheetPerformingRule: IDocumentChargeSheetPerformingRule;
        procedure SetDocumentChargeSheetPerformingRule(Value: IDocumentChargeSheetPerformingRule);

        function GetDocumentChargeSheetOverlappedPerformingRule: IDocumentChargeSheetOverlappedPerformingRule;
        procedure SetDocumentChargeSheetOverlappedPerformingRule(Value: IDocumentChargeSheetOverlappedPerformingRule);

        function GetDocumentChargeSheetIssuingRule: IDocumentChargeSheetIssuingRule;
        procedure SetDocumentChargeSheetIssuingRule(Value: IDocumentChargeSheetIssuingRule);

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
            IDocumentChargeSheetPerformingRule;

          DocumentChargeSheetOverlappedPerformingRule:
            IDocumentChargeSheetOverlappedPerformingRule;

          DocumentChargeSheetIssuingRule:
            IDocumentChargeSheetIssuingRule

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
        
        property DocumentChargeSheetPerformingRule: IDocumentChargeSheetPerformingRule
        read GetDocumentChargeSheetPerformingRule
        write SetDocumentChargeSheetPerformingRule;

        property DocumentChargeSheetOverlappedPerformingRule: IDocumentChargeSheetOverlappedPerformingRule
        read GetDocumentChargeSheetOverlappedPerformingRule
        write SetDocumentChargeSheetOverlappedPerformingRule;

        property DocumentChargeSheetIssuingRule: IDocumentChargeSheetIssuingRule
        read GetDocumentChargeSheetIssuingRule
        write SetDocumentChargeSheetIssuingRule;

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
    IDocumentChargeSheetPerformingRule;

  DocumentChargeSheetOverlappedPerformingRule:
    IDocumentChargeSheetOverlappedPerformingRule;

  DocumentChargeSheetIssuingRule:
    IDocumentChargeSheetIssuingRule

);
begin

  inherited Create;

  FDocumentChargeSheetViewingRule := DocumentChargeSheetViewingRule;
  FDocumentChargeSheetChangingRule := DocumentChargeSheetChangingRule;
  FDocumentChargeSheetRemovingRule := DocumentChargeSheetRemovingRule;
  FDocumentChargeSheetPerformingRule := DocumentChargeSheetPerformingRule;

  FDocumentChargeSheetOverlappedPerformingRule :=
    DocumentChargeSheetOverlappedPerformingRule;

  FDocumentChargeSheetIssuingRule := DocumentChargeSheetIssuingRule;
    
end;

function TDocumentChargeSheetWorkingRules.
  GetDocumentChargeSheetChangingRule: IDocumentChargeSheetChangingRule;
begin

  Result := FDocumentChargeSheetChangingRule;

end;

function TDocumentChargeSheetWorkingRules.GetDocumentChargeSheetIssuingRule: IDocumentChargeSheetIssuingRule;
begin

  Result := FDocumentChargeSheetIssuingRule;

end;

function TDocumentChargeSheetWorkingRules.
  GetDocumentChargeSheetOverlappedPerformingRule: IDocumentChargeSheetOverlappedPerformingRule;
begin

  Result := FDocumentChargeSheetOverlappedPerformingRule;
  
end;

function TDocumentChargeSheetWorkingRules.
  GetDocumentChargeSheetPerformingRule: IDocumentChargeSheetPerformingRule;
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

procedure TDocumentChargeSheetWorkingRules.SetDocumentChargeSheetIssuingRule(
  Value: IDocumentChargeSheetIssuingRule);
begin

  FDocumentChargeSheetIssuingRule := Value;
  
end;

procedure TDocumentChargeSheetWorkingRules.SetDocumentChargeSheetOverlappedPerformingRule(
  Value: IDocumentChargeSheetOverlappedPerformingRule);
begin

  FDocumentChargeSheetOverlappedPerformingRule := Value;

end;

procedure TDocumentChargeSheetWorkingRules.SetDocumentChargeSheetPerformingRule(
  Value: IDocumentChargeSheetPerformingRule);
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
