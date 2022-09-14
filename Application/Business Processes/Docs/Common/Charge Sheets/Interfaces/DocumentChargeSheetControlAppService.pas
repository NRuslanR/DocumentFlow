unit DocumentChargeSheetControlAppService;

interface

uses

  ApplicationService,
  DocumentChargeSheetsChangesInfoDTO,
  DocumentChargeSheetsInfoDTO,
  VariantListUnit,
  SysUtils,
  Classes;

type

  IDocumentChargeSheetControlAppServiceCommand = interface
  
  end;

  TSavingDocumentChargeSheetChangesCommand =
    class (TInterfacedObject, IDocumentChargeSheetControlAppServiceCommand)

      private

        FSavingChangesEmployeeId: Variant;
        FDocumentId: Variant;
        FDocumentChargeSheetsChangesInfoDTO: TDocumentChargeSheetsChangesInfoDTO;

      public

        constructor Create(
          SavingChangesEmployeeId: Variant;
          DocumentId: Variant;
          DocumentChargeSheetsChangesInfoDTO: TDocumentChargeSheetsChangesInfoDTO
        );
      
        destructor Destroy; override;

      published

        property SavingChangesEmployeeId: Variant
        read FSavingChangesEmployeeId;

        property DocumentId: Variant read FDocumentId;
        
        property DocumentChargeSheetsChangesInfoDTO: TDocumentChargeSheetsChangesInfoDTO
        read FDocumentChargeSheetsChangesInfoDTO;

    end;

  TDocumentChargeSheetControlAppServiceException = 
    class (TApplicationServiceException)

    end;
  
  IDocumentChargeSheetControlAppService = interface (IApplicationService)
    ['{697BC0AA-531B-4EA7-B51C-0D104772EC4D}']

    function CreateHeadChargeSheet(
      const DocumentId: Variant;
      const PerformerId: Variant;
      const IssuerId: Variant
    ): TDocumentChargeSheetInfoDTO; overload;

    function CreateSubordinateChargeSheet(
      const DocumentId: Variant;
      const PerformerId: Variant;
      const IssuerId: Variant;
      const TopLevelChargeSheetId: Variant
    ): TDocumentChargeSheetInfoDTO; overload;

    function CreateHeadChargeSheet(
      const ChargeKindId: Variant;
      const DocumentId: Variant;
      const PerformerId: Variant;
      const IssuerId: Variant
    ): TDocumentChargeSheetInfoDTO; overload;

    function CreateSubordinateChargeSheet(
      const ChargeKindId: Variant;
      const DocumentId: Variant;
      const PerformerId: Variant;
      const IssuerId: Variant;
      const TopLevelChargeSheetId: Variant
    ): TDocumentChargeSheetInfoDTO; overload;

    procedure PerformChargeSheet(
      const EmployeeId: Variant;
      const ChargeSheetId: Variant;
      const DocumentId: Variant
    );

    procedure PerformChargeSheets(
      const EmployeeId: Variant;
      const ChargeSheetIds: TVariantList;
      const DocumentId: Variant
    );

    procedure SaveDocumentChargeSheetsChanges(
      Command: TSavingDocumentChargeSheetChangesCommand
    );

  end;

implementation

{ TSavingDocumentChargeSheetChangesCommand }

constructor TSavingDocumentChargeSheetChangesCommand.Create(
  SavingChangesEmployeeId: Variant;
  DocumentId: Variant;
  DocumentChargeSheetsChangesInfoDTO: TDocumentChargeSheetsChangesInfoDTO
);
begin

  inherited Create;

  FSavingChangesEmployeeId := SavingChangesEmployeeId;
  FDocumentId := DocumentId;
  FDocumentChargeSheetsChangesInfoDTO := DocumentChargeSheetsChangesInfoDTO;
  
end;

destructor TSavingDocumentChargeSheetChangesCommand.Destroy;
begin

  FreeAndNil(FDocumentChargeSheetsChangesInfoDTO);
  
  inherited;

end;

end.
