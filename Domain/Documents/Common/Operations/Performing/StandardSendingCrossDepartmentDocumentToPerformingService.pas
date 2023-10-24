unit StandardSendingCrossDepartmentDocumentToPerformingService;

interface

uses

  CreatingNecessaryDataForDocumentPerformingService,
  CreatingNecessaryDataForCrossDepartmentDocumentPerformingService,
  DocumentChargeSheetDirectory,
  IncomingDocumentDirectory,
  StandardSendingDocumentToPerformingService,
  SysUtils;

type

  TStandardSendingCrossDepartmentDocumentToPerformingService =
    class (TStandardSendingDocumentToPerformingService)

      protected

        FIncomingDocumentDirectory: IIncomingDocumentDirectory;

        procedure SaveNecessaryDataForDocumentPerforming(
          NecessaryDataForDocumentPerforming: TNecessaryDataForDocumentPerforming
        ); override;

      public

        constructor Create(

          CreatingNecessaryDataForCrossDepartmentDocumentPerformingService:
            ICreatingNecessaryDataForCrossDepartmentDocumentPerformingService;

          DocumentChargeSheetDirectory: IDocumentChargeSheetDirectory;
          IncomingDocumentDirectory: IIncomingDocumentDirectory
        );
      
    end;


implementation
  
constructor TStandardSendingCrossDepartmentDocumentToPerformingService.Create(

  CreatingNecessaryDataForCrossDepartmentDocumentPerformingService:
    ICreatingNecessaryDataForCrossDepartmentDocumentPerformingService;

  DocumentChargeSheetDirectory: IDocumentChargeSheetDirectory;
  IncomingDocumentDirectory: IIncomingDocumentDirectory
);
begin

  inherited Create(
    CreatingNecessaryDataForCrossDepartmentDocumentPerformingService,
    DocumentChargeSheetDirectory
  );

  FIncomingDocumentDirectory := IncomingDocumentDirectory;

end;

procedure TStandardSendingCrossDepartmentDocumentToPerformingService.
  SaveNecessaryDataForDocumentPerforming(
    NecessaryDataForDocumentPerforming: TNecessaryDataForDocumentPerforming
  );
begin

  inherited SaveNecessaryDataForDocumentPerforming(
    NecessaryDataForDocumentPerforming
  );

  with
    TNecessaryDataForCrossDepartmentDocumentPerforming(
      NecessaryDataForDocumentPerforming
    )
  do
    FIncomingDocumentDirectory.PutDocuments(IncomingDocuments);

end;

end.
