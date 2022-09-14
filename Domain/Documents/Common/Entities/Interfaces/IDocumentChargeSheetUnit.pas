{ Для служебных целей:
  избежание рекурсивных ссылок модулей
}
unit IDocumentChargeSheetUnit;

interface

uses

  DocumentCharges,
  Employee,
  IGetSelfUnit,
  TimeFrame;

type

  IDocumentChargeSheet = interface (IGetSelf)

    function GetCharge: TDocumentCharge;

    function GetIssuer: TEmployee;
    procedure SetIssuer(
      Issuer: TEmployee
    );

    function GetIdentity: Variant;
    procedure SetIdentity(Identity: Variant);

    function GetKindId: Variant;
    procedure SetKindId(const Value: Variant);

    function GetKindName: String;
    procedure SetKindName(const Value: String);

    function GetServiceKindName: String;
    procedure SetServiceKindName(const Value: String);

    function GetChargeText: String;
    procedure SetChargeText(const ChargeText: String);

    function GetTimeFrameStart: Variant;
    procedure SetTimeFrameStart(const Value: Variant);

    function GetTimeFrameDeadline: Variant;
    procedure SetTimeFrameDeadline(const Value: Variant);
      
    function GetPerformer: TEmployee;
    procedure SetPerformer(Performer: TEmployee);

    function GetPerformerResponse: String;
    procedure SetPerformerResponse(const Value: String);

    function GetActuallyPerformedEmployee: TEmployee;
    procedure SetActuallyPerformedEmployee(const Value: TEmployee);

    function GetDocumentId: Variant;
    procedure SetDocumentId(const DocumentId: Variant);

    function GetDocumentKindId: Variant;
    procedure SetDocumentKindId(const Value: Variant);

    function GetTopLevelChargeSheetId: Variant;
    procedure SetTopLevelChargeSheetId(const TopLevelChargeSheetId: Variant);

    function GetIsForAcquaitance: Boolean;
    procedure SetIsForAcquaitance(const Value: Boolean);

    function GetPerformingDateTime: Variant;
    procedure SetPerformingDateTime(const Value: Variant);

    function GetIssuingDateTime: Variant;
    procedure SetIssuingDateTime(const Value: Variant);

    function GetIsHead: Boolean;
    function GetIsPerformed: Boolean;
    function GetIsTimeFrameExpired: Boolean;

    function GetEditingEmployee: TEmployee;
    procedure SetEditingEmployee(EditingEmployee: TEmployee);

    function GetIsRequired: Boolean;

    function IssuerPropName: String;
    function ChargeTextPropName: String;
    function TimeFrameStartPropName: String;
    function TimeFrameDeadlinePropName: String;
    function PerformerPropName: String;
    function PerformerResponsePropName: String;
    function ActuallyPerformedEmployeePropName: String;
    function DocumentIdPropName: String;
    function TopLevelChargeSheetIdPropName: String;
    function IssuingDateTimePropName: String;
    function PerformingDateTimePropName: String;

    procedure SyncIdentityByChargeIdentity;
      
    procedure SetResponseBy(
      const Response: String;
      Performer: TEmployee
    );

    procedure EnsureBelongsToDocument(const DocumentId: Variant);
      
    procedure PerformBy(
      Performer: TEmployee;
      const PerformingDateTime: TDateTime = 0
    );

    procedure PerformAsOverlappedBy(
      OverlappingChargeSheet: IDocumentChargeSheet;
      ActualPerformer: TEmployee;
      const PerformingDateTime: TDateTime = 0
    );

    function PerformAsOverlappedIfPossible(
      OverlappingChargeSheet: IDocumentChargeSheet;
      ActualPerformer: TEmployee;
      const PerformingDateTime: TDateTime = 0
    ): Boolean;

    procedure MarkAsNonRequired;

    procedure SetTimeFrameStartAndDeadline(
      const TimeFrameStart, TimeFrameDeadline: TDateTime
    );

    property Identity: Variant
    read GetIdentity write SetIdentity;
    
    property EditingEmployee: TEmployee
    read GetEditingEmployee write SetEditingEmployee;

    property Charge: TDocumentCharge read GetCharge;

    property KindId: Variant
    read GetKindId write SetKindId;

    property KindName: String
    read GetKindName write SetKindName;

    property ServiceKindName: String
    read GetServiceKindName write SetServiceKindName;
      
    property Issuer: TEmployee
    read GetIssuer write SetIssuer;

    property ChargeText: String
    read GetChargeText write SetChargeText;

    property TimeFrameStart: Variant
    read GetTimeFrameStart write SetTimeFrameStart;

    property TimeFrameDeadline: Variant
    read GetTimeFrameDeadline write SetTimeFrameDeadline;

    property Performer: TEmployee
    read GetPerformer write SetPerformer;

    property PerformerResponse: String
    read GetPerformerResponse write SetPerformerResponse;

    property ActuallyPerformedEmployee: TEmployee
    read GetActuallyPerformedEmployee
    write SetActuallyPerformedEmployee;

    property DocumentId: Variant
    read GetDocumentId write SetDocumentId;

    property DocumentKindId: Variant
    read GetDocumentKindId write SetDocumentKindId;

    property TopLevelChargeSheetId: Variant
    read GetTopLevelChargeSheetId write SetTopLevelChargeSheetId;

    property IsPerformed: Boolean
    read GetIsPerformed;

    property IssuingDateTime: Variant
    read GetIssuingDateTime write SetIssuingDateTime;
      
    property PerformingDateTime: Variant
    read GetPerformingDateTime write SetPerformingDateTime;

    property IsTimeFrameExpired: Boolean
    read GetIsTimeFrameExpired;

    property IsForAcquaitance: Boolean
    read GetIsForAcquaitance write SetIsForAcquaitance;
      
    property IsHead: Boolean read GetIsHead;

    property IsRequired: Boolean read GetIsRequired;

  end;

  IDocumentChargeSheetsEnumerator = interface

  end;

  IDocumentChargeSheets = interface (IGetSelf)

  end;

implementation

end.
