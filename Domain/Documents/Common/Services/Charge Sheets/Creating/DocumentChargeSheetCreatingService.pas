unit DocumentChargeSheetCreatingService;

interface

uses

  SysUtils,
  DocumentChargeInterface,
  IDocumentChargeSheetUnit,
  DocumentChargeSheetAccessRights,
  DocumentChargeSheet,
  IDocumentUnit,
  DomainException,
  Employee,
  Classes;

type

  TDocumentChargeSheetCreatingServiceException = class (TDomainException)
  
  end;

  IDocumentChargeSheetCreatingService = interface
    ['{02233001-3D67-452F-9A39-A2631CFCDB9D}']

    procedure CreateHeadDocumentChargeSheet(
      Document: IDocument;
      Issuer, Performer: TEmployee;
      var ChargeSheet: IDocumentChargeSheet;
      var AccessRights: TDocumentChargeSheetAccessRights;
      const IssuingDateTime: TDateTime = 0
    ); overload;

    procedure CreateSubordinateDocumentChargeSheet(
      TopLevelChargeSheet: IDocumentChargeSheet;
      Document: IDocument;
      Issuer, Performer: TEmployee;
      var ChargeSheet: IDocumentChargeSheet;
      var AccessRights: TDocumentChargeSheetAccessRights;
      const IssuingDateTime: TDateTime = 0
    ); overload;

    procedure CreateHeadDocumentChargeSheet(
      const ChargeKindId: Variant;
      Document: IDocument;
      Issuer, Performer: TEmployee;
      var ChargeSheet: IDocumentChargeSheet;
      var AccessRights: TDocumentChargeSheetAccessRights;
      const IssuingDateTime: TDateTime = 0
    ); overload;

    procedure CreateSubordinateDocumentChargeSheet(
      const ChargeKindId: Variant;
      TopLevelChargeSheet: IDocumentChargeSheet;
      Document: IDocument;
      Issuer, Performer: TEmployee;
      var ChargeSheet: IDocumentChargeSheet;
      var AccessRights: TDocumentChargeSheetAccessRights;
      const IssuingDateTime: TDateTime = 0
    ); overload;
    
  end;

implementation

end.
