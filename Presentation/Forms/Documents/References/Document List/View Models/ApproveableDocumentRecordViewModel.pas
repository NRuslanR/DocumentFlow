unit ApproveableDocumentRecordViewModel;

interface

uses

  DocumentRecordViewModelDecorator,
  SysUtils;

type

  TApproveableDocumentRecordViewModel = class (TDocumentRecordViewModelDecorator)

    public

      SenderDepartmentName: String;
      ReceiverDepartmentNames: String;
      
  end;
  

implementation

end.
