unit StandardIncomingDocumentApprovingListCreatingAppService;

interface

uses

  DocumentApprovingListDTO,
  DocumentApprovingListCreatingAppService,
  IncomingDocumentRepository,
  AbstractApplicationService,
  SysUtils,
  Classes;

type

  TStandardIncomingDocumentApprovingListCreatingAppService =
    class (
      TAbstractApplicationService,
      IDocumentApprovingListCreatingAppService
    )

      protected

        FIncomingDocumentRepository: IIncomingDocumentRepository;
        
        FDocumentApprovingListCreatingAppService:
          IDocumentApprovingListCreatingAppService;
          
      public

        constructor Create(

          DocumentApprovingListCreatingAppService:
            IDocumentApprovingListCreatingAppService;

          IncomingDocumentRepository: IIncomingDocumentRepository
          
        );

        function CreateDocumentApprovingListsForDocument(
          const DocumentId: Variant
        ): TDocumentApprovingListDTOs;

    end;

implementation

uses

  IDomainObjectUnit,
  IncomingDocument;
  
{ TStandardIncomingDocumentApprovingListCreatingAppService }

constructor TStandardIncomingDocumentApprovingListCreatingAppService.Create(
  DocumentApprovingListCreatingAppService: IDocumentApprovingListCreatingAppService;
  IncomingDocumentRepository: IIncomingDocumentRepository
);
begin

  inherited Create;

  FDocumentApprovingListCreatingAppService :=
    DocumentApprovingListCreatingAppService;

  FIncomingDocumentRepository :=
    IncomingDocumentRepository;
  
end;

function TStandardIncomingDocumentApprovingListCreatingAppService.
  CreateDocumentApprovingListsForDocument(
    const DocumentId: Variant
  ): TDocumentApprovingListDTOs;
var IncomingDocument: TIncomingDocument;
    FreeIncomingDocument: IDomainObject;
begin

  IncomingDocument :=
    FIncomingDocumentRepository.FindIncomingDocumentById(DocumentId);

  FreeIncomingDocument := IncomingDocument;

  Result :=
    FDocumentApprovingListCreatingAppService.
      CreateDocumentApprovingListsForDocument(
        IncomingDocument.OriginalDocument.Identity
      );
  
end;

end.
