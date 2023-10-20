unit OutcomingDocumentRecordViewModel;

interface

uses

  DocumentRecordViewModel,
  DocumentRecordViewModelDecorator,
  SysUtils,
  Classes;

type

  TOutcomingDocumentRecordViewModel = class (TDocumentRecordViewModelDecorator)

    protected

      FReceivingDepartmentNames: String;

    public

      property ReceivingDepartmentNames: String
      read FReceivingDepartmentNames write FReceivingDepartmentNames;
      
  end;
  
implementation


end.
