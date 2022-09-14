unit NotPerformedDocumentsReportData;

interface

uses

  AbstractDataSetHolder,
  SysUtils,
  Classes,
  DB;

type

  TNotPerformedDocumentSetFieldDefs = class (TAbstractDataSetFieldDefs)

    public

      NumberFieldName: String;
      CreationDateFieldName: String;
      NameFieldName: String;
      ContentFieldName: String;
      LeaderShortNameFieldName: String;
      PerformerShortNamesFieldName: String;
      DeparmentShortNameFieldName: String;
      
  end;

  TNotPerformedDocumentSetHolder = class (TAbstractDataSetHolder)

    protected

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;
      
    protected

      function GetContentFieldName: String;
      function GetCreationDateFieldName: String;
      function GetDeparmentShortNameFieldName: String;
      function GetLeaderShortNameFieldName: String;
      function GetNameFieldName: String;
      function GetNotPerformedDocumentSetFieldDefs: TNotPerformedDocumentSetFieldDefs;
      function GetOutcomingNumberFieldName: String;
      function GetPerformerShortNamesFieldName: String;

      procedure SetContentFieldName(const Value: String);
      procedure SetCreationDateFieldName(const Value: String);
      procedure SetDeparmentShortNameFieldName(const Value: String);
      procedure SetLeaderShortNameFieldName(const Value: String);
      procedure SetNameFieldName(const Value: String);

      procedure SetNotPerformedDocumentSetFieldDefs(
        const Value: TNotPerformedDocumentSetFieldDefs);

      procedure SetOutcomingNumberFieldName(const Value: String);
      procedure SetPerformerShortNamesFieldName(const Value: String);
      function GetContentFieldValue: String;
      function GetCreationDateFieldValue: TDateTime;
      function GetDeparmentShortNameFieldValue: String;
      function GetLeaderShortNameFieldValue: String;
      function GetNameFieldValue: String;
      function GetOutcomingNumberFieldValue: String;
      function GetPerformerShortNamesFieldValue: String;
      procedure SetContentFieldValue(const Value: String);
      procedure SetCreationDateFieldValue(const Value: TDateTime);
      procedure SetDeparmentShortNameFieldValue(const Value: String);
      procedure SetLeaderShortNameFieldValue(const Value: String);
      procedure SetNameFieldValue(const Value: String);
      procedure SetOutcomingNumberFieldValue(const Value: String);
      procedure SetPerformerShortNamesFieldValue(const Value: String);

    public

      property NumberFieldName: String
      read GetOutcomingNumberFieldName write SetOutcomingNumberFieldName;

      property CreationDateFieldName: String
      read GetCreationDateFieldName write SetCreationDateFieldName;

      property NameFieldName: String
      read GetNameFieldName write SetNameFieldName;

      property ContentFieldName: String
      read GetContentFieldName write SetContentFieldName;

      property LeaderShortNameFieldName: String
      read GetLeaderShortNameFieldName write SetLeaderShortNameFieldName;

      property PerformerShortNamesFieldName: String
      read GetPerformerShortNamesFieldName write SetPerformerShortNamesFieldName;

      property DeparmentShortNameFieldName: String
      read GetDeparmentShortNameFieldName write SetDeparmentShortNameFieldName;

    public

      property OutcomingNumberFieldValue: String
      read GetOutcomingNumberFieldValue write SetOutcomingNumberFieldValue;

      property CreationDateFieldValue: TDateTime
      read GetCreationDateFieldValue write SetCreationDateFieldValue;

      property NameFieldValue: String
      read GetNameFieldValue write SetNameFieldValue;

      property ContentFieldValue: String
      read GetContentFieldValue write SetContentFieldValue;

      property LeaderShortNameFieldValue: String
      read GetLeaderShortNameFieldValue write SetLeaderShortNameFieldValue;

      property PerformerShortNamesFieldValue: String
      read GetPerformerShortNamesFieldValue write SetPerformerShortNamesFieldValue;

      property DeparmentShortNameFieldValue: String
      read GetDeparmentShortNameFieldValue write SetDeparmentShortNameFieldValue;
      
    public

      property FieldDefs: TNotPerformedDocumentSetFieldDefs
      read GetNotPerformedDocumentSetFieldDefs
      write SetNotPerformedDocumentSetFieldDefs;

  end;
  
  TNotPerformedDocumentsReportData = class

    private

      FPeriodStart: TDateTime;
      FPeriodEnd: TDateTime;
      FReportCreationDepartment: String;
      FNotPerformedDocumentCount: Integer;
      FReportDataSetHolder: TNotPerformedDocumentSetHolder;

    public

      destructor Destroy; override;
      
      constructor Create;
      constructor CreateFrom(
        const PeriodStart, PeriodEnd: TDateTime;
        const ReportCreationDepartment: String;
        const NotPerformedDocumentCount: Integer;
        ReportDataSetHolder: TNotPerformedDocumentSetHolder
      );

    published

      property PeriodStart: TDateTime read FPeriodStart write FPeriodStart;
      property PeriodEnd: TDateTime read FPeriodEnd write FPeriodEnd;

      property ReportCreationDepartment: String
      read FReportCreationDepartment
      write FReportCreationDepartment;

      property NotPerformedDocumentCount: Integer
      read FNotPerformedDocumentCount
      write FNotPerformedDocumentCount;
      
      property ReportDataSetHolder: TNotPerformedDocumentSetHolder
      read FReportDataSetHolder write FReportDataSetHolder;

  end;

implementation

{ TNotPerformedDocumentsReportData }

constructor TNotPerformedDocumentsReportData.Create;
begin

  inherited;

end;

constructor TNotPerformedDocumentsReportData.CreateFrom(
  const PeriodStart, PeriodEnd: TDateTime;
  const ReportCreationDepartment: String;
  const NotPerformedDocumentCount: Integer;
  ReportDataSetHolder: TNotPerformedDocumentSetHolder
);
begin

  inherited Create;

  FPeriodStart := PeriodStart;
  FPeriodEnd := PeriodEnd;
  FReportCreationDepartment := ReportCreationDepartment;
  FNotPerformedDocumentCount := NotPerformedDocumentCount;
  FReportDataSetHolder := ReportDataSetHolder;

end;

destructor TNotPerformedDocumentsReportData.Destroy;
begin

  FreeAndNil(FReportDataSetHolder);

  inherited;

end;

{ TNotPerformedDocumentSetHolder }

function TNotPerformedDocumentSetHolder.GetContentFieldName: String;
begin

  Result := FieldDefs.ContentFieldName;

end;

function TNotPerformedDocumentSetHolder.GetContentFieldValue: String;
begin

  Result := GetDataSetFieldValue(ContentFieldName, '');

end;

function TNotPerformedDocumentSetHolder.GetCreationDateFieldName: String;
begin

  Result := FieldDefs.CreationDateFieldName;

end;

function TNotPerformedDocumentSetHolder.GetCreationDateFieldValue: TDateTime;
begin

  Result := GetDataSetFieldValue(CreationDateFieldName, 0);

end;

class function TNotPerformedDocumentSetHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TNotPerformedDocumentSetFieldDefs;
  
end;

function TNotPerformedDocumentSetHolder.GetDeparmentShortNameFieldName: String;
begin

  Result := FieldDefs.DeparmentShortNameFieldName;
  
end;

function TNotPerformedDocumentSetHolder.GetDeparmentShortNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(DeparmentShortNameFieldName, '');
  
end;

function TNotPerformedDocumentSetHolder.GetLeaderShortNameFieldName: String;
begin

  Result := FieldDefs.LeaderShortNameFieldName;

end;

function TNotPerformedDocumentSetHolder.GetLeaderShortNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(LeaderShortNameFieldName, '');
  
end;

function TNotPerformedDocumentSetHolder.GetNameFieldName: String;
begin

  Result := FieldDefs.NameFieldName;

end;

function TNotPerformedDocumentSetHolder.GetNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(NameFieldName, '');

end;

function TNotPerformedDocumentSetHolder.GetNotPerformedDocumentSetFieldDefs: TNotPerformedDocumentSetFieldDefs;
begin

  Result := TNotPerformedDocumentSetFieldDefs(inherited FieldDefs);
  
end;

function TNotPerformedDocumentSetHolder.GetOutcomingNumberFieldName: String;
begin

  Result := FieldDefs.NumberFieldName;

end;

function TNotPerformedDocumentSetHolder.GetOutcomingNumberFieldValue: String;
begin

  Result := GetDataSetFieldValue(NumberFieldName, '');
  
end;

function TNotPerformedDocumentSetHolder.GetPerformerShortNamesFieldName: String;
begin

  Result := FieldDefs.PerformerShortNamesFieldName;

end;

function TNotPerformedDocumentSetHolder.GetPerformerShortNamesFieldValue: String;
begin

  Result := GetDataSetFieldValue(PerformerShortNamesFieldName, '');

end;

procedure TNotPerformedDocumentSetHolder.SetContentFieldName(
  const Value: String);
begin

  FieldDefs.ContentFieldName := Value;

end;

procedure TNotPerformedDocumentSetHolder.SetContentFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(ContentFieldName, Value);

end;

procedure TNotPerformedDocumentSetHolder.SetCreationDateFieldName(
  const Value: String);
begin

  FieldDefs.CreationDateFieldName := Value;

end;

procedure TNotPerformedDocumentSetHolder.SetCreationDateFieldValue(
  const Value: TDateTime);
begin

  SetDataSetFieldValue(CreationDateFieldName, Value);
  
end;

procedure TNotPerformedDocumentSetHolder.SetDeparmentShortNameFieldName(
  const Value: String);
begin

  FieldDefs.DeparmentShortNameFieldName := Value;
  
end;

procedure TNotPerformedDocumentSetHolder.SetDeparmentShortNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(DeparmentShortNameFieldName, Value);
  
end;

procedure TNotPerformedDocumentSetHolder.SetLeaderShortNameFieldName(
  const Value: String);
begin

  FieldDefs.LeaderShortNameFieldName := Value;
  
end;

procedure TNotPerformedDocumentSetHolder.SetLeaderShortNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(LeaderShortNameFieldName, Value);
  
end;

procedure TNotPerformedDocumentSetHolder.SetNameFieldName(const Value: String);
begin

  FieldDefs.NameFieldName := Value;

end;

procedure TNotPerformedDocumentSetHolder.SetNameFieldValue(const Value: String);
begin

  SetDataSetFieldValue(NameFieldName, Value);
  
end;

procedure TNotPerformedDocumentSetHolder.SetNotPerformedDocumentSetFieldDefs(
  const Value: TNotPerformedDocumentSetFieldDefs);
begin

  inherited FieldDefs := Value
  ;
end;

procedure TNotPerformedDocumentSetHolder.SetOutcomingNumberFieldName(
  const Value: String);
begin

  FieldDefs.NumberFieldName := Value;

end;

procedure TNotPerformedDocumentSetHolder.SetOutcomingNumberFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(NumberFieldName, Value);

end;

procedure TNotPerformedDocumentSetHolder.SetPerformerShortNamesFieldName(
  const Value: String);
begin

  FieldDefs.PerformerShortNamesFieldName := Value;
  
end;

procedure TNotPerformedDocumentSetHolder.SetPerformerShortNamesFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(PerformerShortNamesFieldName, Value);
  
end;

end.
