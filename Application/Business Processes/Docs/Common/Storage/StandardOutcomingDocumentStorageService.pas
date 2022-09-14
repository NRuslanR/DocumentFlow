unit StandardOutcomingDocumentStorageService;

interface

uses

  Document,
  DocumentUsageEmployeeAccessRightsInfoDTO,
  Employee,
  StandardDocumentStorageService,
  Session,
  DocumentDirectory,
  IDocumentUnit,
  IEmployeeRepositoryUnit,
  DocumentInfoReadService,
  DocumentUsageEmployeeAccessRightsService,
  DocumentObjectsDTODomainMapper,
  DocumentCreatingService,
  DocumentFullInfoDTOMapper,
  SysUtils,
  Classes;

type

  TStandardOutcomingDocumentStorageService =
    class (TStandardDocumentStorageService)

      protected

        function EnsureThatEmployeeHasDocumentUsageAccessRights(
          Document: IDocument;
          RequestingEmployee: TEmployee
        ): TDocumentUsageEmployeeAccessRightsInfoDTO; override;

      public

        constructor Create(

          Session: ISession;
          DocumentDirectory: IDocumentDirectory;
          EmployeeRepository: IEmployeeRepository;
          DocumentCreatingService: IDocumentCreatingService;
          DocumentInfoReadService: IDocumentInfoReadService;
          DocumentUsageEmployeeAccessRightsService: IDocumentUsageEmployeeAccessRightsService;
          DocumentObjectsDTODomainMapper: TDocumentObjectsDTODomainMapper;
          DocumentFullInfoDTOMapper: TDocumentFullInfoDTOMapper

        ); override;
        
    end;

implementation

{ TStandardOutcomingDocumentStorageService }

constructor TStandardOutcomingDocumentStorageService.Create(
  Session: ISession;
  DocumentDirectory: IDocumentDirectory;
  EmployeeRepository: IEmployeeRepository;
  DocumentCreatingService: IDocumentCreatingService;
  DocumentInfoReadService: IDocumentInfoReadService;
  DocumentUsageEmployeeAccessRightsService: IDocumentUsageEmployeeAccessRightsService;
  DocumentObjectsDTODomainMapper: TDocumentObjectsDTODomainMapper;
  DocumentFullInfoDTOMapper: TDocumentFullInfoDTOMapper
);
begin

  inherited Create(
    Session,
    DocumentDirectory,
    EmployeeRepository,
    DocumentCreatingService,
    DocumentInfoReadService,
    DocumentUsageEmployeeAccessRightsService,
    DocumentObjectsDTODomainMapper,
    DocumentFullInfoDTOMapper
  );

end;

function TStandardOutcomingDocumentStorageService.EnsureThatEmployeeHasDocumentUsageAccessRights(
  Document: IDocument;
  RequestingEmployee: TEmployee
): TDocumentUsageEmployeeAccessRightsInfoDTO;
begin

  Result :=
    inherited EnsureThatEmployeeHasDocumentUsageAccessRights(
      Document, RequestingEmployee
    );

  if Result.AnyChargeSheetsCanBeViewed then begin

    with Result.DocumentChargeSheetsAccessRightsInfoDTO do begin

      AnyChargeSheetsCanBeIssued := False;
      AnyChargeSheetsCanBeChanged := False;
      AnyChargeSheetsCanBeRemoved := False;
      AnyChargeSheetsCanBePerformed := False;

    end;

  end;
  
end;

end.
