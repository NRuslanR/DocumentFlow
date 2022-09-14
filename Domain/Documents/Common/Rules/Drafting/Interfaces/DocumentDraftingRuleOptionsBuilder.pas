unit DocumentDraftingRuleOptionsBuilder;

interface

uses

  DocumentDraftingRuleOptions,
  SysUtils;

type

  IDocumentDraftingRuleOptionsBuilder = interface

    function BuildFor(DocumentClass: TClass): IDocumentDraftingRuleCompoundOptions;
     
  end;
  
implementation

end.
