unit DocumentStorageService;

interface

uses

  ApplicationService,
  VariantListUnit,
  DocumentFullInfoDTO,
  NewDocumentInfoDTO,
  ChangedDocumentInfoDTO,
  DocumentStorageServiceCommandsAndRespones,
  DocumentUsageEmployeeAccessRightsInfoDTO,
  SysUtils,
  Classes;

type

  IDocumentStorageService = interface (IApplicationService)
    ['{3181FD87-0E74-46A7-8BCF-4F1A5586E392}']

    function CreateDocument(
      DocumentCreatingCommand: IDocumentCreatingCommand
    ): IDocumentCreatingCommandResult;

    function GetDocumentFullInfo(
      GettingDocumentFullInfoCommand: TGettingDocumentFullInfoCommand
    ): IGettingDocumentFullInfoCommandResult;
      
    function AddNewDocumentFullInfo(
      AddNewDocumentFullInfoCommand: TAddNewDocumentFullInfoCommand
    ): IAddNewDocumentFullInfoCommandResult;

    procedure ChangeDocumentInfo(
      ChangeDocumentInfoCommand: TChangeDocumentInfoCommand
    );

    procedure ChangeDocumentApprovingsInfo(
      ChangeDocumentApprovingsInfoCommand: TChangeDocumentApprovingsInfoCommand
    );
    
    procedure RemoveDocumentsInfo(
      RemoveDocumentsInfoCommand: TRemoveDocumentsInfoCommand
    );

  end;

implementation

end.
