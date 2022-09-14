unit BasedOnRepositoryDocumentChargeSheetDirectory;

interface

uses

  DocumentChargeSheet,
  DocumentChargeSheetFinder,
  AbstractDocumentChargeSheetDirectory,
  IDocumentChargeSheetUnit,
  DocumentChargeSheetRepository,
  SysUtils,
  Classes;

type

  TBasedOnRepositoryDocumentChargeSheetDirectory =
    class (TAbstractDocumentChargeSheetDirectory)

      protected

        FDocumentChargeSheetRepository: IDocumentChargeSheetRepository;

      public

        constructor Create(
          DocumentChargeSheetFinder: IDocumentChargeSheetFinder;
          DocumentChargeSheetRepository: IDocumentChargeSheetRepository
        );
        
        procedure PutDocumentChargeSheet(
          DocumentChargeSheet: IDocumentChargeSheet
        ); override;

        procedure PutDocumentChargeSheets(
          DocumentChargeSheets: TDocumentChargeSheets
        ); override;

        procedure ModifyDocumentChargeSheet(
          DocumentChargeSheet: IDocumentChargeSheet
        ); override;

        procedure ModifyDocumentChargeSheets(
          DocumentChargeSheets: TDocumentChargeSheets
        ); override;

        procedure RemoveDocumentChargeSheet(
          DocumentChargeSheet: IDocumentChargeSheet
        ); override;

        procedure RemoveDocumentChargeSheets(
          DocumentChargeSheets: TDocumentChargeSheets
        ); override;

        procedure RemoveDocumentChargeSheetWithAllSubordinates(
          DocumentChargeSheet: IDocumentChargeSheet
        ); override;

        procedure RemoveDocumentChargeSheetsWithAllSubordinates(
          DocumentChargeSheets: TDocumentChargeSheets
        ); override;
        
        procedure RemoveAllChargeSheetsForDocument(
          const DocumentId: Variant
        ); override;

      
    end;

implementation

{ TBasedOnRepositoryDocumentChargeSheetDirectory }

constructor TBasedOnRepositoryDocumentChargeSheetDirectory.Create(
  DocumentChargeSheetFinder: IDocumentChargeSheetFinder;
  DocumentChargeSheetRepository: IDocumentChargeSheetRepository);
begin

  inherited Create(DocumentChargeSheetFinder);

  FDocumentChargeSheetRepository := DocumentChargeSheetRepository;
  
end;

procedure TBasedOnRepositoryDocumentChargeSheetDirectory.ModifyDocumentChargeSheet(
  DocumentChargeSheet: IDocumentChargeSheet);
begin

  FDocumentChargeSheetRepository.UpdateDocumentChargeSheet(
    TDocumentChargeSheet(DocumentChargeSheet.Self)
  );

end;

procedure TBasedOnRepositoryDocumentChargeSheetDirectory.ModifyDocumentChargeSheets(
  DocumentChargeSheets: TDocumentChargeSheets);
begin

  FDocumentChargeSheetRepository.UpdateDocumentChargeSheets(DocumentChargeSheets);

end;

procedure TBasedOnRepositoryDocumentChargeSheetDirectory.PutDocumentChargeSheet(
  DocumentChargeSheet: IDocumentChargeSheet);
begin

  FDocumentChargeSheetRepository.AddDocumentChargeSheet(
    TDocumentChargeSheet(DocumentChargeSheet.Self)
  );

end;

procedure TBasedOnRepositoryDocumentChargeSheetDirectory.PutDocumentChargeSheets(
  DocumentChargeSheets: TDocumentChargeSheets);
begin

  FDocumentChargeSheetRepository.AddDocumentChargeSheets(DocumentChargeSheets);

end;

procedure TBasedOnRepositoryDocumentChargeSheetDirectory.RemoveAllChargeSheetsForDocument(
  const DocumentId: Variant);
begin

  FDocumentChargeSheetRepository.RemoveAllChargeSheetsForDocument(DocumentId);

end;

procedure TBasedOnRepositoryDocumentChargeSheetDirectory.RemoveDocumentChargeSheet(
  DocumentChargeSheet: IDocumentChargeSheet);
begin

  FDocumentChargeSheetRepository.RemoveDocumentChargeSheet(
    TDocumentChargeSheet(DocumentChargeSheet.Self)
  );

end;

procedure TBasedOnRepositoryDocumentChargeSheetDirectory.RemoveDocumentChargeSheets(
  DocumentChargeSheets: TDocumentChargeSheets);
begin

  FDocumentChargeSheetRepository.RemoveDocumentChargeSheets(DocumentChargeSheets);

end;

procedure TBasedOnRepositoryDocumentChargeSheetDirectory.RemoveDocumentChargeSheetsWithAllSubordinates(
  DocumentChargeSheets: TDocumentChargeSheets);
begin

  FDocumentChargeSheetRepository.RemoveDocumentChargeSheetsWithAllSubordinates(
    DocumentChargeSheets
  );

end;

procedure TBasedOnRepositoryDocumentChargeSheetDirectory
  .RemoveDocumentChargeSheetWithAllSubordinates(
    DocumentChargeSheet: IDocumentChargeSheet
  );
begin

  FDocumentChargeSheetRepository
    .RemoveDocumentChargeSheetWithAllSubordinates(
      TDocumentChargeSheet(DocumentChargeSheet.Self)
    );

end;

end.
