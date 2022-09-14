unit StandardDocumentDraftingRuleOptionsBuilder;

interface

uses

  DocumentDraftingRuleOptionsBuilder,
  DocumentDraftingRuleOptions,
  SysUtils;

type

  TStandardDocumentDraftingRuleOptionsBuilder =
    class (TInterfacedObject, IDocumentDraftingRuleOptionsBuilder)

      private

        function BuildForPersonnelOrder: IDocumentDraftingRuleCompoundOptions;
        function BuildForRest: IDocumentDraftingRuleCompoundOptions;
        
      public

        function BuildFor(DocumentClass: TClass): IDocumentDraftingRuleCompoundOptions;
        
    end;
  
implementation

uses

  StandardDocumentDraftingRuleOptions,
  PersonnelOrder,
  ServiceNote,
  Document;
  
{ TStandardDocumentDraftingRuleOptionsBuilder }

function TStandardDocumentDraftingRuleOptionsBuilder.BuildFor(
  DocumentClass: TClass): IDocumentDraftingRuleCompoundOptions;
begin

  if DocumentClass.InheritsFrom(TPersonnelOrder) then
    Result := BuildForPersonnelOrder

  else Result := BuildForRest;
  
end;

function TStandardDocumentDraftingRuleOptionsBuilder.BuildForPersonnelOrder: IDocumentDraftingRuleCompoundOptions;
begin

  Result := BuildForRest;

  Result
    .ContentAssigningRequired(False)
    .ChargesAssigningRequired(False);

  Result
    .ApprovingSending
      .ContentAssigningRequired(False)
      .ChargesAssigningRequired(False);

  Result
    .Signing
      .ContentAssigningRequired(False)
      .ChargesAssigningRequired(False);

end;

function TStandardDocumentDraftingRuleOptionsBuilder.BuildForRest: IDocumentDraftingRuleCompoundOptions;
begin

  Result := TDocumentDraftingRuleCompoundOptions.Create;

  Result
    .NumberAssigningRequired(False)
    .ContentAssigningRequired(True)
    .ChargesAssigningRequired(True)
    .ResponsibleAssigningRequired(True);

  Result
    .ApprovingSending
      .From(Result);

  Result
    .Signing
      .From(Result)
      .NumberAssigningRequired(True);

end;

end.
