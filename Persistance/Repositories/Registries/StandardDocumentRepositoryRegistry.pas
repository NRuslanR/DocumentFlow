unit StandardDocumentRepositoryRegistry;

interface

uses

  DocumentRepositoryRegistry,
  DocumentFilesRepository,
  DocumentRelationsRepository,
  DocumentRepository,
  IncomingDocumentRepository,
  IDocumentResponsibleRepositoryUnit,
  IncomingDocument,
  Document,
  RepositoryList,
  DocumentKindRepository,
  DocumentWorkCycleRepository,
  DocumentApprovingCycleResultRepository,
  DocumentChargeSheetRepository,
  DocumentKind,
  DocumentChargeSheet,
  DocumentApprovingRepository,
  DocumentChargeKindRepository,
  SysUtils,
  Classes;

type

  TStandardDocumentRepositoryRegistry =
    class (TInterfacedObject, IDocumentRepositoryRegistry)

      private

        FDocumentRepositories: TRepositories;
        FDocumentRelationsRepositories: TRepositories;
        FDocumentFilesRepositories: TRepositories;
        FDocumentChargeSheetRepositories: TRepositories;
        FDocumentApprovingRepositories: TRepositories;
        FDocumentApprovingCycleResultRepositories: TRepositories;
        FDocumentWorkCycleRepositories: TRepositories;

        FDocumentChargeKindsRepository: IDocumentChargeKindRepository;
        
      public

        destructor Destroy; override;
        constructor Create;

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

        procedure RegisterDocumentKindRepository(
          DocumentKindRepository: IDocumentKindRepository
        );

        procedure RegisterDocumentResponsibleRepository(
          DocumentResponsibleRepository: IDocumentResponsibleRepository
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

        procedure RegisterDocumentApprovingRepository(
          DocumentClass: TDocumentClass;
          DocumentApprovingRepository: IDocumentApprovingRepository
        );

        procedure RegisterDocumentChargeKindRepository(
          DocumentChargeKindRepository: IDocumentChargeKindRepository
        );

        function GetDocumentChargeKindRepository: IDocumentChargeKindRepository;

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

uses

  ServiceNote,
  DateUtils,
  IncomingServiceNote;
  
{ TStandardDocumentRepositoryRegistry }

constructor TStandardDocumentRepositoryRegistry.Create;
begin

  inherited Create;

  FDocumentRepositories := TRepositories.Create;
  FDocumentRelationsRepositories := TRepositories.Create;
  FDocumentFilesRepositories := TRepositories.Create;
  FDocumentApprovingCycleResultRepositories := TRepositories.Create;
  FDocumentChargeSheetRepositories := TRepositories.Create;
  FDocumentApprovingRepositories := TRepositories.Create;
  FDocumentWorkCycleRepositories := TRepositories.Create;
  
end;

destructor TStandardDocumentRepositoryRegistry.Destroy;
begin

  FreeAndNil(FDocumentRepositories);
  FreeAndNil(FDocumentRelationsRepositories);
  FreeAndNil(FDocumentFilesRepositories);
  FreeAndNil(FDocumentApprovingCycleResultRepositories);
  FreeAndNil(FDocumentChargeSheetRepositories);
  FreeAndNil(FDocumentApprovingRepositories);
  FreeAndNil(FDocumentWorkCycleRepositories);
  
  inherited;

end;

function TStandardDocumentRepositoryRegistry.GetDocumentFilesRepository(
  DocumentClass: TDocumentClass): IDocumentFilesRepository;
begin

  Result :=
    IDocumentFilesRepository(
      FDocumentFilesRepositories[DocumentClass]
    );
    
end;

function TStandardDocumentRepositoryRegistry.GetDocumentRelationsRepository(
  DocumentClass: TDocumentClass): IDocumentRelationsRepository;
begin

  Result :=
    IDocumentRelationsRepository(
      FDocumentRelationsRepositories[DocumentClass]
    );

end;

function TStandardDocumentRepositoryRegistry.GetDocumentRepository(
  DocumentClass: TDocumentClass): IDocumentRepository;
begin

  Result :=
    IDocumentRepository(
      FDocumentRepositories[DocumentClass]
    );
    
end;

function TStandardDocumentRepositoryRegistry.GetIncomingDocumentRepository(
  IncomingDocumentClass: TIncomingDocumentClass): IIncomingDocumentRepository;
var DocumentRepository: IInterface;
begin

  DocumentRepository := FDocumentRepositories[IncomingDocumentClass];

  Supports(DocumentRepository, IIncomingDocumentRepository, Result);
    
end;

procedure TStandardDocumentRepositoryRegistry.RegisterDocumentApprovingCycleResultRepository(
  DocumentClass: TDocumentClass;
  DocumentApprovingCycleResultRepository: IDocumentApprovingCycleResultRepository);
begin

  FDocumentApprovingCycleResultRepositories.AddOrUpdateRepository(
    DocumentClass, DocumentApprovingCycleResultRepository
  );

end;

procedure TStandardDocumentRepositoryRegistry.RegisterDocumentApprovingRepository(
  DocumentClass: TDocumentClass;
  DocumentApprovingRepository: IDocumentApprovingRepository
);
begin

  FDocumentApprovingRepositories.AddOrUpdateRepository(
    DocumentClass, DocumentApprovingRepository
  );

end;

procedure TStandardDocumentRepositoryRegistry.RegisterDocumentChargeKindRepository(
  DocumentChargeKindRepository: IDocumentChargeKindRepository);
begin

  FDocumentChargeKindsRepository := DocumentChargeKindRepository;
  
end;

procedure TStandardDocumentRepositoryRegistry.RegisterDocumentChargeSheetRepository(
  DocumentClass: TDocumentClass;
  DocumentChargeSheetRepository: IDocumentChargeSheetRepository
);
begin

  FDocumentChargeSheetRepositories.AddOrUpdateRepository(
    DocumentClass,
    DocumentChargeSheetRepository
  );

end;

procedure TStandardDocumentRepositoryRegistry.RegisterDocumentFilesRepository(
  DocumentClass: TDocumentClass;
  DocumentFilesRepository: IDocumentFilesRepository);
begin

  FDocumentFilesRepositories.AddOrUpdateRepository(
    DocumentClass, DocumentFilesRepository
  );
  
end;

procedure TStandardDocumentRepositoryRegistry.RegisterDocumentKindRepository(
  DocumentKindRepository: IDocumentKindRepository);
begin

  FDocumentRepositories.AddOrUpdateRepository(
    TDocumentKind, DocumentKindRepository
  );
  
end;

procedure TStandardDocumentRepositoryRegistry.RegisterDocumentRelationsRepository(
  DocumentClass: TDocumentClass;
  DocumentRelationsRepository: IDocumentRelationsRepository);
begin

  FDocumentRelationsRepositories.AddOrUpdateRepository(
    DocumentClass, DocumentRelationsRepository
  );
  
end;

procedure TStandardDocumentRepositoryRegistry.RegisterDocumentRepository(
  DocumentClass: TDocumentClass; DocumentRepository: IDocumentRepository);
begin

  FDocumentRepositories.AddOrUpdateRepository(
    DocumentClass, DocumentRepository
  );
  
end;

procedure TStandardDocumentRepositoryRegistry.RegisterDocumentResponsibleRepository(
  DocumentResponsibleRepository: IDocumentResponsibleRepository);
begin

  FDocumentRepositories.AddOrUpdateRepository(
    TDocumentResponsible, DocumentResponsibleRepository
  );

end;

procedure TStandardDocumentRepositoryRegistry.RegisterDocumentWorkCycleRepository(
  DocumentClass: TDocumentClass;
  DocumentWorkCycleRepository: IDocumentWorkCycleRepository
);
begin

  FDocumentWorkCycleRepositories.AddOrUpdateRepository(
    DocumentClass, DocumentWorkCycleRepository
  );
  
end;

procedure TStandardDocumentRepositoryRegistry.RegisterIncomingDocumentRepository(
  IncomingDocumentClass: TIncomingDocumentClass;
  IncomingDocumentRepository: IIncomingDocumentRepository);
begin

  FDocumentRepositories.AddOrUpdateRepository(
    IncomingDocumentClass, IncomingDocumentRepository
  );
  
end;

function TStandardDocumentRepositoryRegistry.GetDocumentChargeKindRepository: IDocumentChargeKindRepository;
begin

  Result := FDocumentChargeKindsRepository;
  
end;

function TStandardDocumentRepositoryRegistry.GetDocumentChargeSheetRepository(DocumentClass: TDocumentClass): IDocumentChargeSheetRepository;
begin

  Result :=
    IDocumentChargeSheetRepository(
      FDocumentChargeSheetRepositories[DocumentClass]
    );

end;

function TStandardDocumentRepositoryRegistry.GetDocumentKindRepository: IDocumentKindRepository;
begin

  Result := IDocumentKindRepository(FDocumentRepositories[TDocumentKind]);
  
end;

function TStandardDocumentRepositoryRegistry.GetDocumentResponsibleRepository: IDocumentResponsibleRepository;
begin

  Result := IDocumentResponsibleRepository(FDocumentRepositories[TDocumentResponsible]);

end;

function TStandardDocumentRepositoryRegistry.GetDocumentWorkCycleRepository(
  DocumentClass: TDocumentClass): IDocumentWorkCycleRepository;
begin

  Result := IDocumentWorkCycleRepository(FDocumentWorkCycleRepositories[DocumentClass]);
  
end;

function TStandardDocumentRepositoryRegistry.GetDocumentApprovingCycleResultRepository(
  DocumentClass: TDocumentClass): IDocumentApprovingCycleResultRepository;
begin

  Result :=
    IDocumentApprovingCycleResultRepository(
      FDocumentApprovingCycleResultRepositories[DocumentClass]
    );

end;

function TStandardDocumentRepositoryRegistry.GetDocumentApprovingRepository(
  DocumentClass: TDocumentClass): IDocumentApprovingRepository;
begin

  Result :=
    IDocumentApprovingRepository(
      FDocumentApprovingRepositories[DocumentClass]
    );
    
end;

end.
