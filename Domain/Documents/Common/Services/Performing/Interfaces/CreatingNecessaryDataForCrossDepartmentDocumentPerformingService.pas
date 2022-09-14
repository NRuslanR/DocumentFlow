unit CreatingNecessaryDataForCrossDepartmentDocumentPerformingService;

interface

uses

  Document,
  IncomingDocument,
  DocumentChargeSheet,
  IDomainObjectBaseListUnit,
  CreatingNecessaryDataForDocumentPerformingService,
  SysUtils;

type

  TNecessaryDataForCrossDepartmentDocumentPerforming =
    class (TNecessaryDataForDocumentPerforming)

      private

        FIncomingDocuments: TIncomingDocuments;
        FFreeIncomingDocuments: IDomainObjectBaseList;
        
        procedure SetIncomingDocuments(const Value: TIncomingDocuments);
        
      public

        destructor Destroy; override;
        
        constructor Create; override;
        constructor CreateFrom(DocumentChargeSheets: TDocumentChargeSheets); override;

      public

        property IncomingDocuments: TIncomingDocuments
        read FIncomingDocuments write SetIncomingDocuments;

    end;
    
  ICreatingNecessaryDataForCrossDepartmentDocumentPerformingService =
    interface (ICreatingNecessaryDataForDocumentPerformingService)
      ['{0FFC1C47-AC21-4402-9ED4-2FC67A5E4117}']
      
    end;
    
implementation

uses

  Variants;
  
constructor TNecessaryDataForCrossDepartmentDocumentPerforming.Create;
begin

  inherited;

end;

constructor TNecessaryDataForCrossDepartmentDocumentPerforming.CreateFrom(
  DocumentChargeSheets: TDocumentChargeSheets
);
begin

  inherited CreateFrom(DocumentChargeSheets);

end;

destructor TNecessaryDataForCrossDepartmentDocumentPerforming.Destroy;
begin

  inherited;

end;

procedure TNecessaryDataForCrossDepartmentDocumentPerforming.SetIncomingDocuments(
  const Value: TIncomingDocuments);
begin

  FIncomingDocuments := Value;
  FFreeIncomingDocuments := FIncomingDocuments;
  
end;

end.
