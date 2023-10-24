unit DocumentChargeSheetControlService;

interface

uses

  DocumentChargeSheet,
  DocumentCharges,
  DomainException,
  IDocumentChargeSheetUnit,
  DomainObjectValueUnit,
  DocumentChargeSheetPerformingResult,
  DocumentChargeSheetAccessRights,
  Document,
  IDocumentUnit,
  VariantListUnit,
  Employee;

type

  TDocumentChargeSheetControlServiceException = class (TDomainException)

  end;

  IDocumentChargeSheetControlService = interface

    function GetChargeSheets(
      Employee: TEmployee;
      const ChargeSheetIds: TVariantList
    ): TDocumentChargeSheets;
    
    function GetChargeSheet(
      Employee: TEmployee;
      const ChargeSheetId: Variant
    ): IDocumentChargeSheet; overload;

    procedure GetChargeSheet(
      Employee: TEmployee;
      const ChargeSheetId: Variant;
      var ChargeSheet: IDocumentChargeSheet;
      var AccessRights: TDocumentChargeSheetAccessRights
    ); overload;
    
    procedure CreateHeadChargeSheet(
      Document: IDocument;
      Performer: TEmployee;
      IssuingEmployee: TEmployee;
      var ChargeSheet: IDocumentChargeSheet;
      var AccessRights: TDocumentChargeSheetAccessRights
    ); overload;

    procedure CreateSubordinateChargeSheet(
      Document: IDocument;
      Performer: TEmployee;
      IssuingEmployee: TEmployee;
      TopLevelChargeSheet: IDocumentChargeSheet;
      var ChargeSheet: IDocumentChargeSheet;
      var AccessRights: TDocumentChargeSheetAccessRights
    ); overload;
    
    procedure CreateHeadChargeSheet(
      const ChargeKindId: Variant;
      Document: IDocument;
      Performer: TEmployee;
      IssuingEmployee: TEmployee;
      var ChargeSheet: IDocumentChargeSheet;
      var AccessRights: TDocumentChargeSheetAccessRights
    ); overload;

    procedure CreateSubordinateChargeSheet(
      const ChargeKindId: Variant;
      Document: IDocument;
      Performer: TEmployee;
      IssuingEmployee: TEmployee;
      TopLevelChargeSheet: IDocumentChargeSheet;
      var ChargeSheet: IDocumentChargeSheet;
      var AccessRights: TDocumentChargeSheetAccessRights
    ); overload;

    procedure SaveChargeSheets(
      Employee: TEmployee;
      ChargeSheets: TDocumentChargeSheets
    );

    function PerformChargeSheet(
      Employee: TEmployee;
      ChargeSheet: IDocumentChargeSheet
    ): TDocumentChargeSheetPerformingResult;

    function PerformChargeSheets(
      Employee: TEmployee;
      ChargeSheets: TDocumentChargeSheets
    ): TDocumentChargeSheetPerformingResult;

    procedure RemoveChargeSheets(
      Employee: TEmployee;
      ChargeSheets: TDocumentChargeSheets
    );

  end;

implementation

end.
