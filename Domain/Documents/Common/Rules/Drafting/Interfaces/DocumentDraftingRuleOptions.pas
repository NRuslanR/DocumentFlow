unit DocumentDraftingRuleOptions;

interface

uses

  Disposable;

type

  IDocumentDraftingRuleOptions = interface (IDisposable)

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

  IDocumentDraftingRuleCompoundOptions = interface (IDocumentDraftingRuleOptions)

    function GetSigningOptions: IDocumentDraftingRuleOptions;
    procedure SetSigningOptions(Value: IDocumentDraftingRuleOptions);

    function GetApprovingSendingOptions: IDocumentDraftingRuleOptions;
    procedure SetApprovingSendingOptions(Value: IDocumentDraftingRuleOptions);
    
    property Signing: IDocumentDraftingRuleOptions read GetSigningOptions write SetSigningOptions;
    property ApprovingSending: IDocumentDraftingRuleOptions read GetApprovingSendingOptions write SetApprovingSendingOptions;
    
  end;


implementation

end.
