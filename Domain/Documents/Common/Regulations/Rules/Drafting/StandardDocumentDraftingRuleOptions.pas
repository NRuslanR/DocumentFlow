unit StandardDocumentDraftingRuleOptions;

interface

uses

  DocumentDraftingRuleOptions,
  DocumentDraftingRuleOptionsBuilder,
  SysUtils;

type

  TDocumentDraftingRuleOptions = class (TInterfacedObject, IDocumentDraftingRuleOptions)
      
    protected

      FNumberAssigningRequired: Boolean;
      FContentAssigningRequired: Boolean;
      FChargesAssigningRequired: Boolean;
      FResponsibleAssigningRequired: Boolean;

    public

      function From(Options: IDocumentDraftingRuleOptions): IDocumentDraftingRuleOptions;
      
      function NumberAssigningRequired: Boolean; overload;
      function NumberAssigningRequired(const Value: Boolean): IDocumentDraftingRuleOptions; overload;

      function ContentAssigningRequired: Boolean; overload;
      function ContentAssigningRequired(const Value: Boolean): IDocumentDraftingRuleOptions; overload;

      function ChargesAssigningRequired: Boolean; overload;
      function ChargesAssigningRequired(const Value: Boolean): IDocumentDraftingRuleOptions; overload;

      function ResponsibleAssigningRequired: Boolean; overload;
      function ResponsibleAssigningRequired(const Value: Boolean): IDocumentDraftingRuleOptions; overload;
      
  end;

  TDocumentDraftingRuleCompoundOptions =
    class (TDocumentDraftingRuleOptions, IDocumentDraftingRuleCompoundOptions)

      private

        class var FBuilder: IDocumentDraftingRuleOptionsBuilder;

        class function GetBuilder: IDocumentDraftingRuleOptionsBuilder; static;

      protected

        FSigning: IDocumentDraftingRuleOptions;
        FApprovingSending: IDocumentDraftingRuleOptions;

      public

        constructor Create;
        
        function GetSigningOptions: IDocumentDraftingRuleOptions;
        procedure SetSigningOptions(Value: IDocumentDraftingRuleOptions);

        function GetApprovingSendingOptions: IDocumentDraftingRuleOptions;
        procedure SetApprovingSendingOptions(Value: IDocumentDraftingRuleOptions);

        property Signing: IDocumentDraftingRuleOptions read GetSigningOptions write SetSigningOptions;
        property ApprovingSending: IDocumentDraftingRuleOptions read GetApprovingSendingOptions write SetApprovingSendingOptions;

      public

        class property Builder: IDocumentDraftingRuleOptionsBuilder read GetBuilder write FBuilder;

    end;

  

implementation

uses

  StandardDocumentDraftingRuleOptionsBuilder;

{ TDocumentDraftingRuleOptions }

function TDocumentDraftingRuleOptions.ChargesAssigningRequired: Boolean;
begin

  Result := FChargesAssigningRequired;
  
end;

function TDocumentDraftingRuleOptions.ChargesAssigningRequired(
  const Value: Boolean): IDocumentDraftingRuleOptions;
begin


  FChargesAssigningRequired := Value;

  Result := Self;

end;

function TDocumentDraftingRuleOptions.ContentAssigningRequired(
  const Value: Boolean): IDocumentDraftingRuleOptions;
begin

  FContentAssigningRequired := Value;

  Result := Self;

end;

function TDocumentDraftingRuleOptions.From(
  Options: IDocumentDraftingRuleOptions): IDocumentDraftingRuleOptions;
begin

  NumberAssigningRequired(Options.NumberAssigningRequired);
  ContentAssigningRequired(Options.ContentAssigningRequired);
  ChargesAssigningRequired(Options.ChargesAssigningRequired);
  ResponsibleAssigningRequired(Options.ResponsibleAssigningRequired);

  Result := Self;
  
end;

function TDocumentDraftingRuleOptions.ContentAssigningRequired: Boolean;
begin

  Result := FContentAssigningRequired;
  
end;

function TDocumentDraftingRuleOptions.NumberAssigningRequired(
  const Value: Boolean): IDocumentDraftingRuleOptions;
begin

  FNumberAssigningRequired := Value;

  Result := Self;

end;

function TDocumentDraftingRuleOptions.NumberAssigningRequired: Boolean;
begin

  Result := FNumberAssigningRequired;
  
end;

function TDocumentDraftingRuleOptions.ResponsibleAssigningRequired: Boolean;
begin

  Result := FResponsibleAssigningRequired;

end;

function TDocumentDraftingRuleOptions.ResponsibleAssigningRequired(
  const Value: Boolean): IDocumentDraftingRuleOptions;
begin

  FResponsibleAssigningRequired := Value;

  Result := Self;
  
end;

constructor TDocumentDraftingRuleCompoundOptions.Create;
begin

  inherited;

  FSigning := TDocumentDraftingRuleOptions.Create;
  FApprovingSending := TDocumentDraftingRuleOptions.Create;
  
end;

function TDocumentDraftingRuleCompoundOptions.GetApprovingSendingOptions: IDocumentDraftingRuleOptions;
begin

  Result := FApprovingSending;

end;

function TDocumentDraftingRuleCompoundOptions.GetSigningOptions: IDocumentDraftingRuleOptions;
begin

  Result := FSigning;

end;

procedure TDocumentDraftingRuleCompoundOptions.SetApprovingSendingOptions(
  Value: IDocumentDraftingRuleOptions);
begin

  FApprovingSending := Value;

end;

procedure TDocumentDraftingRuleCompoundOptions.SetSigningOptions(
  Value: IDocumentDraftingRuleOptions);
begin

  FSigning := Value;

end;

class function TDocumentDraftingRuleCompoundOptions.GetBuilder: IDocumentDraftingRuleOptionsBuilder;
begin

  if not Assigned(FBuilder) then
    FBuilder := TStandardDocumentDraftingRuleOptionsBuilder.Create;
    
  Result := FBuilder;

end;

end.
