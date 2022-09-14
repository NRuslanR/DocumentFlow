unit EmployeeDocumentCardFormViewModel;

interface

uses

  DocumentCardFormViewModel,
  SysUtils;

type

  TEmployeeDocumentCardFormViewModel = class (TDocumentCardFormViewModel)

    protected

      FIsViewed: Boolean;

    public

      property IsViewed: Boolean
      read FIsViewed write FIsViewed;
      
  end;
  
implementation

end.
