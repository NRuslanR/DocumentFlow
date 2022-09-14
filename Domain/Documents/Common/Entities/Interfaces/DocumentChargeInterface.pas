unit DocumentChargeInterface;

interface

uses

  IDomainObjectListUnit,
  DomainObjectListUnit,
  IDomainObjectUnit,
  Employee,
  SysUtils;

type

  IDocumentCharge = interface (IDomainObject)
    ['{D547D2BF-6288-4876-9F9B-64359D15CFC7}']

      function GetDocumentId: Variant;
      function GetActuallyPerformedEmployee: TEmployee;
      function GetIsPerformed: Boolean;
      function GetIsRequired: Boolean;
      function GetPerformer: TEmployee;
      function GetTimeFrameDeadline: Variant;
      function GetTimeFrameStart: Variant;
      function GetPerformingDateTime: Variant;
      function GetChargeText: String;
      function GetResponse: String;
      function GetKindId: Variant;
      function GetKindName: String;
      function GetServiceKindName: String;
      function GetIsForAcquaitance: Boolean;

      procedure SetDocumentId(const Value: Variant);
      procedure SetPerformer(const Value: TEmployee);
      procedure SetPerformingDateTime(const Value: Variant);
      procedure SetChargeText(const Value: String);
      procedure SetResponse(const Value: String);
      procedure SetActuallyPerformedEmployee(const Value: TEmployee);
      procedure SetTimeFrameDeadline(const Value: Variant);
      procedure SetTimeFrameStart(const Value: Variant);
      procedure SetKindId(const Value: Variant);
      procedure SetKindName(const Value: String);
      procedure SetServiceKindName(const Value: String);
      procedure SetIsForAcquaitance(const Value: Boolean);

      procedure SetTimeFrameStartAndDeadline(
        const TimeFrameStart, TimeFrameDeadline: TDateTime
      );

      procedure MarkAsPerformedBy(OtherCharge: IDocumentCharge); overload;

      procedure Assign(Charge: IDocumentCharge);

      procedure MarkAsNonRequired;

      function IsTimeFrameExpired: Boolean;

      property KindId: Variant
      read GetKindId write SetKindId;

      property KindName: String
      read GetKindName write SetKindName;

      property ServiceKindName: String
      read GetServiceKindName write SetServiceKindName;

      property DocumentId: Variant
      read GetDocumentId write SetDocumentId;
      
      property Performer: TEmployee
      read GetPerformer write SetPerformer;

      property ActuallyPerformedEmployee: TEmployee
      read GetActuallyPerformedEmployee
      write SetActuallyPerformedEmployee;

      property PerformingDateTime: Variant
      read GetPerformingDateTime write SetPerformingDateTime;

      property TimeFrameStart: Variant
      read GetTimeFrameStart write SetTimeFrameStart;

      property TimeFrameDeadline: Variant
      read GetTimeFrameDeadline write SetTimeFrameDeadline;

      property ChargeText: String
      read GetChargeText write SetChargeText;

      property Response: String
      read GetResponse write SetResponse;
      
      property IsPerformed: Boolean read GetIsPerformed;

      property IsRequired: Boolean read GetIsRequired;

      property IsForAcquaitance: Boolean
      read GetIsForAcquaitance write SetIsForAcquaitance;
      
  end;

  IDocumentCharges = interface;
  
  TDocumentChargesEnumerator = class (TDomainObjectListEnumerator)

    protected

      function GetCurrentDocumentCharge: IDocumentCharge;

    public

      constructor Create(DocumentCharges: TDomainObjectList);

      property Current: IDocumentCharge
      read GetCurrentDocumentCharge;

  end;

  IDocumentCharges = interface (IDomainObjectList)
    ['{1573A610-D291-46A1-8827-B00A7B446629}']

    function GetDocumentChargeByIndex(Index: Integer): IDocumentCharge;
    
    procedure SetDocumentChargeByIndex(
      Index: Integer;
      DocumentCharge: IDocumentCharge
    );

    function First: IDocumentCharge;
    function Last: IDocumentCharge;
    
    function FindByIdentity(const Identity: Variant): IDocumentCharge;

    procedure AddCharge(Charge: IDocumentCharge);
    procedure ChangeCharge(Charge: IDocumentCharge);

    procedure MarkChargeAsPerformedBy(OtherCharge: IDocumentCharge); 

    procedure RemoveChargeFor(Employee: TEmployee);
    procedure RemoveAllCharges;

    function IsEmpty: Boolean;                 

    function AreAllChargesPerformed: Boolean;
    function IsEmployeeAssignedAsPerformer(Employee: TEmployee): Boolean;
    function IsEmployeeActuallyPerformed(Employee: TEmployee): Boolean;

    function GetEnumerator: TDocumentChargesEnumerator;

    function FindDocumentChargeByPerformerOrActuallyPerformedEmployee(Employee: TEmployee): IDocumentCharge;

    procedure Clear;
      
    property Items[Index: Integer]: IDocumentCharge
    read GetDocumentChargeByIndex
    write SetDocumentChargeByIndex; default;

  end;

implementation

constructor TDocumentChargesEnumerator.Create(
  DocumentCharges: TDomainObjectList
);
begin

  inherited Create(DocumentCharges);
  
end;

function TDocumentChargesEnumerator.GetCurrentDocumentCharge: IDocumentCharge;
begin

  Supports(GetCurrentDomainObject, IDocumentCharge, Result);
  
end;

end.
