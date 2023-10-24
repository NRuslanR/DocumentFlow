unit StandardIncomingDocumentCreatingService;

interface

uses

  IncomingDocumentCreatingService,
  Document,
  DocumentKindFinder,
  IncomingDocument,
  DocumentKind,
  Employee,
  SysUtils;

type

  TStandardIncomingDocumentCreatingService =
    class (TInterfacedObject, IIncomingDocumentCreatingService)

      protected

        FIncomingDocumentType: TIncomingDocumentClass;
        FDocumentKindFinder: IDocumentKindFinder;
        
      public

        constructor Create(
          DocumentKindFinder: IDocumentKindFinder;
          IncomingDocumentType: TIncomingDocumentClass
        );
        
        function CreateIncomingDocumentInstanceFor(
          Document: TDocument;
          Receiver: TEmployee
        ): TIncomingDocument;

    end;


implementation

uses

  IDomainObjectBaseUnit,
  DocumentRuleRegistry,
  DocumentSpecificationRegistry;

{ TStandardIncomingDocumentCreatingService }

constructor TStandardIncomingDocumentCreatingService.Create(
  DocumentKindFinder: IDocumentKindFinder;
  IncomingDocumentType: TIncomingDocumentClass
);
begin

  inherited Create;

  FDocumentKindFinder := DocumentKindFinder;

  FIncomingDocumentType := IncomingDocumentType;
  
end;

function TStandardIncomingDocumentCreatingService
  .CreateIncomingDocumentInstanceFor(
    Document: TDocument;
    Receiver: TEmployee
  ): TIncomingDocument;
var
    DocumentKind: TDocumentKind;
    FreeDocumentKind: IDomainObjectBase;
begin

  DocumentKind := FDocumentKindFinder.FindDocumentKindByClassType(FIncomingDocumentType);

  FreeDocumentKind := DocumentKind;
  
  Result := FIncomingDocumentType.Create(Document, Receiver.Identity);

  try

    Result.KindIdentity := DocumentKind.Identity;

    {
      refactor: lines below are deprecated as incoming document is a
      just original document wrapper using for the accounting at
      the receiver's side and it hasn't any working rules therefore
    }
    
    Result.WorkingRules :=
      TDocumentRuleRegistry
        .GetEmployeeDocumentWorkingRules(FIncomingDocumentType);

    Result.Specifications :=
      TDocumentSpecificationRegistry
        .Instance
          .GetDocumentSpecifications(FIncomingDocumentType);
          
  except

    FreeAndNil(Result);

    Raise;

  end;

end;

end.
