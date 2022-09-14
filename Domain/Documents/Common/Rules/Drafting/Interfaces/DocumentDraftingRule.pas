unit DocumentDraftingRule;

interface

uses

  DocumentDraftingRuleOptions,
  DocumentDraftingRuleOptionsBuilder,
  DomainException,
  IDocumentUnit,
  Disposable,
  SysUtils,
  Classes;

type

  TDocumentDraftingRuleException = class (TDomainException)

  end;

  IDocumentDraftingRule = interface

    procedure EnsureThatDocumentDraftedCorrectly(
      Document: IDocument
    ); overload;

    procedure EnsureThatDocumentDraftedCorrectlyForSigning(
      Document: IDocument
    );

    procedure EnsureThatDocumentDraftedCorrectlyForApprovingSending(
      Document: IDocument
    );

    function GetOptions: IDocumentDraftingRuleCompoundOptions;
    procedure SetOptions(const Value: IDocumentDraftingRuleCompoundOptions);

    property Options: IDocumentDraftingRuleCompoundOptions
    read GetOptions write SetOptions;
    
  end;

implementation

end.
