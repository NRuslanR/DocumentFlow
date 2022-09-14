unit DocumentPerformingRule;

interface

uses

  DomainException,
  Employee,
  IDocumentUnit;

type

  TDocumentPerformingRuleException = class (TDomainException)


  end;
  
  IDocumentPerformingRule = interface

    procedure EnsureThatDocumentMayBeMarkedAsPerformed(
      Document: IDocument;
      FormalPerformer: TEmployee;
      ActuallyPerformedEmployee: TEmployee
    );

    function MayDocumentBeMarkedAsPerformed(
      Document: IDocument;
      FormalPerformer: TEmployee;
      ActuallyPerformedEmployee: TEmployee
    ): Boolean;

  end;

implementation

end.
