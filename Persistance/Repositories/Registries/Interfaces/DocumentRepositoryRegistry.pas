unit DocumentRepositoryRegistry;

interface

uses

  Document,
  DocumentChargeSheet,
  IncomingDocumentRepository,
  DocumentRepository,
  IncomingDocument,
  DocumentFilesRepository,
  DocumentRelationsRepository,
  DocumentApprovingRepository,
  IDocumentResponsibleRepositoryUnit,
  DocumentKindRepository,
  DocumentApprovingCycleResultRepository,
  DocumentChargeSheetRepository,
  DocumentWorkCycleRepository,
  DocumentChargeKindRepository,
  SysUtils;
  
type

  TDocumentRepositoryRegistryException = class (Exception)

  end;

  IDocumentRepositoryRegistry = interface

    function GetDocumentFilesRepository(
      DocumentClass: TDocumentClass
    ): IDocumentFilesRepository;
    
    procedure RegisterDocumentFilesRepository(
      DocumentClass: TDocumentClass;
      DocumentFilesRepository: IDocumentFilesRepository
    );

    function GetDocumentRelationsRepository(
      DocumentClass: TDocumentClass
    ): IDocumentRelationsRepository;
    
    procedure RegisterDocumentRelationsRepository(
      DocumentClass: TDocumentClass;
      DocumentRelationsRepository: IDocumentRelationsRepository
    );

    procedure RegisterDocumentRepository(
      DocumentClass: TDocumentClass;
      DocumentRepository: IDocumentRepository
    );

    procedure RegisterIncomingDocumentRepository(
      IncomingDocumentClass: TIncomingDocumentClass;
      IncomingDocumentRepository: IIncomingDocumentRepository
    );

    function GetDocumentRepository(
      DocumentClass: TDocumentClass
    ): IDocumentRepository;

    function GetIncomingDocumentRepository(
      IncomingDocumentClass: TIncomingDocumentClass
    ): IIncomingDocumentRepository;

    procedure RegisterDocumentResponsibleRepository(DocumentResponsibleRepository: IDocumentResponsibleRepository);

    procedure RegisterDocumentKindRepository(
      DocumentKindRepository: IDocumentKindRepository
    );

    function GetDocumentKindRepository: IDocumentKindRepository;

    function GetDocumentResponsibleRepository: IDocumentResponsibleRepository;

    procedure RegisterDocumentApprovingCycleResultRepository(
      DocumentClass: TDocumentClass;
      DocumentApprovingCycleResultRepository:
        IDocumentApprovingCycleResultRepository
    );

    function GetDocumentApprovingCycleResultRepository(
      DocumentClass: TDocumentClass
    ): IDocumentApprovingCycleResultRepository;

    procedure RegisterDocumentChargeSheetRepository(
      DocumentClass: TDocumentClass;
      DocumentChargeSheetRepository: IDocumentChargeSheetRepository
    );

    function GetDocumentChargeSheetRepository(DocumentClass: TDocumentClass): IDocumentChargeSheetRepository;

    procedure RegisterDocumentChargeKindRepository(
      DocumentChargeKindRepository: IDocumentChargeKindRepository
    );

    function GetDocumentChargeKindRepository: IDocumentChargeKindRepository;

    procedure RegisterDocumentApprovingRepository(
      DocumentClass: TDocumentClass;
      DocumentApprovingRepository: IDocumentApprovingRepository
    );

    function GetDocumentApprovingRepository(
      DocumentClass: TDocumentClass
    ): IDocumentApprovingRepository;

    function GetDocumentWorkCycleRepository(
      DocumentClass: TDocumentClass
    ): IDocumentWorkCycleRepository;

    procedure RegisterDocumentWorkCycleRepository(
      DocumentClass: TDocumentClass;
      DocumentWorkCycleRepository: IDocumentWorkCycleRepository
    );
    
  end;
  
implementation

end.
