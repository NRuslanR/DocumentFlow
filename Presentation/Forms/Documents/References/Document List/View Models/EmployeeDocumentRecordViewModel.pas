unit EmployeeDocumentRecordViewModel;

interface

uses

  DocumentRecordViewModel,
  DocumentRecordViewModelDecorator,
  SysUtils;

type

  TEmployeeDocumentRecordViewModel = class (TDocumentRecordViewModelDecorator)

    protected

      FIsViewed: Variant;
      FOwnChargeSheet: Variant;
      FAllChargeSheetsPerformed: Variant;
      FAllSubordinateChargeSheetsPerformed: Variant;

      procedure Initialize; override;
      
    public

      property IsViewed: Variant read FIsViewed write FIsViewed;
      property OwnChargeSheet: Variant read FOwnChargeSheet write FOwnChargeSheet;
      property AllChargeSheetsPerformed: Variant read FAllChargeSheetsPerformed write FAllChargeSheetsPerformed;
      
      property AllSubordinateChargeSheetsPerformed: Variant
      read FAllSubordinateChargeSheetsPerformed write FAllSubordinateChargeSheetsPerformed;

  end;
  
implementation

uses

  Variants;
  
{ TEmployeeDocumentRecordViewModel }


procedure TEmployeeDocumentRecordViewModel.Initialize;
begin

  inherited;

  FIsViewed := Null;
  FOwnChargeSheet := Null;
  FAllChargeSheetsPerformed := Null;
  FAllSubordinateChargeSheetsPerformed := Null;

end;

end.
