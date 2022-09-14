unit DepartmentDocumentSetHolder;

interface

uses

  DocumentSetHolder,
  AbstractDataSetHolder,
  AbstractDocumentSetHolderDecorator,
  SysUtils,
  Classes;

type

  TDepartmentDocumentSetFieldDefs = class (TAbstractDocumentSetFieldDefsDecorator)

  end;
  
  TDepartmentDocumentSetHolder = class (TAbstractDocumentSetHolderDecorator)

    private

      function GetDepartmentDocumentSetFieldDefs:
        TDepartmentDocumentSetFieldDefs;

      procedure SetDepartmentDocumentSetFieldDefs(
        const Value: TDepartmentDocumentSetFieldDefs
      );
    
    protected

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;

    public

      property FieldDefs: TDepartmentDocumentSetFieldDefs
      read GetDepartmentDocumentSetFieldDefs
      write SetDepartmentDocumentSetFieldDefs;
      
  end;

implementation

{ TDepartmentDocumentSetHolder }

class function TDepartmentDocumentSetHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TDepartmentDocumentSetFieldDefs;

end;

function TDepartmentDocumentSetHolder.
  GetDepartmentDocumentSetFieldDefs: TDepartmentDocumentSetFieldDefs;
begin

  Result := TDepartmentDocumentSetFieldDefs(inherited FieldDefs);
  
end;

procedure TDepartmentDocumentSetHolder.SetDepartmentDocumentSetFieldDefs(
  const Value: TDepartmentDocumentSetFieldDefs);
begin

  inherited FieldDefs := Value;
  
end;

end.
