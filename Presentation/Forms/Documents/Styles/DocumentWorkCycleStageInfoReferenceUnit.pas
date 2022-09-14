{ refactor:
  ������� � ������� ViewModel-��������
  ����������� �� DTO, ���������������
  ���������� �������, �������, � ���� �������,
  ��������� ���� DTO �� ������ � ����� ����������,
  ������������ ���������� �������
}
unit DocumentWorkCycleStageInfoReferenceUnit;

interface

uses

  UIDocumentKinds,
  Classes,
  SysUtils;

type

  TDocumentWorkCycleStageInfoReference = class

    public

      class function GetStageNumberOfCreatedForDocumentKind(
        UIDocumentKind: TUIDocumentKindClass
      ): Integer; static;

      class function GetSigningStageNumberForDocumentKind(
        UIDocumentKind: TUIDocumentKindClass
      ): Integer; static;

      class function GetStageNumberOfRejectedForDocumentKind(
        UIDocumentKind: TUIDocumentKindClass
      ): Integer; static;

      class function GetPerformingStageNumberForDocumentKind(
        UIDocumentKind: TUIDocumentKindClass
      ): Integer; static;

      class function GetStageNumberOfPerformedForDocumentKind(
        UIDocumentKind: TUIDocumentKindClass
      ): Integer; static;

      class function GetStageNamesForDocumentKind(
        UIDocumentKind: TUIDocumentKindClass
      ): TStrings; static;

    public

      class function GetStageNameOfCreatedForDocumentKind(
        UIDocumentKind: TUIDocumentKindClass
      ): String; static;

      class function GetSigningStageNameForDocumentKind(
        UIDocumentKind: TUIDocumentKindClass
      ): String; static;

      class function GetStageNameOfRejectedForDocumentKind(
        UIDocumentKind: TUIDocumentKindClass
      ): String; static;

      class function GetPerformingStageNameForDocumentKind(
        UIDocumentKind: TUIDocumentKindClass
      ): String; static;

      class function GetStageNameOfPerformedForDocumentKind(
        UIDocumentKind: TUIDocumentKindClass
      ): String; static;
      
  end;

implementation

{ TDocumentWorkCycleStageInfoReference }

class function TDocumentWorkCycleStageInfoReference.
  GetPerformingStageNameForDocumentKind(
    UIDocumentKind: TUIDocumentKindClass
  ): String;
begin

  Result := '�� ����������';

end;

class function TDocumentWorkCycleStageInfoReference.
GetPerformingStageNumberForDocumentKind(
  UIDocumentKind: TUIDocumentKindClass
): Integer;
begin

  if UIDocumentKind.InheritsFrom(TUIOutcomingDocumentKind) then
      Result := 7

  else if UIDocumentKind.InheritsFrom(TUIIncomingDocumentKind) then
      Result := 1

  else Result := 7;

end;

class function TDocumentWorkCycleStageInfoReference.
  GetSigningStageNameForDocumentKind(
    UIDocumentKind: TUIDocumentKindClass
  ): String;
begin

  Result := '�� ����������';

end;

class function TDocumentWorkCycleStageInfoReference.GetSigningStageNumberForDocumentKind(
  UIDocumentKind: TUIDocumentKindClass
): Integer;
begin

  if UIDocumentKind.InheritsFrom(TUIOutcomingDocumentKind) then
      Result := 5

  else if UIDocumentKind.InheritsFrom(TUIIncomingDocumentKind) then
      Result := -1

  else Result := 5;

end;

class function TDocumentWorkCycleStageInfoReference.
  GetStageNameOfCreatedForDocumentKind(
    UIDocumentKind: TUIDocumentKindClass
  ): String;
begin

  if UIDocumentKind.InheritsFrom(TUIOutcomingDocumentKind) or
     UIDocumentKind.InheritsFrom(TUIIncomingServiceNoteKind)
  then begin

    Result := '�������';

  end

  else Result := '������';
  
end;

class function TDocumentWorkCycleStageInfoReference.
  GetStageNameOfPerformedForDocumentKind(
    UIDocumentKind: TUIDocumentKindClass
  ): String;
begin

  if UIDocumentKind.InheritsFrom(TUIOutcomingServiceNoteKind) or
     UIDocumentKind.InheritsFrom(TUIIncomingServiceNoteKind)
  then begin

    Result := '���������';

  end

  else Result := '��������';
  
end;

class function TDocumentWorkCycleStageInfoReference.
  GetStageNameOfRejectedForDocumentKind(
    UIDocumentKind: TUIDocumentKindClass
  ): String;
begin

  if UIDocumentKind.InheritsFrom(TUIOutcomingServiceNoteKind) or
     UIDocumentKind.InheritsFrom(TUIIncomingServiceNoteKind)

  then begin

    Result := '���������';

  end

  else Result := '��������';
  

end;

class function TDocumentWorkCycleStageInfoReference.
  GetStageNamesForDocumentKind(
    UIDocumentKind: TUIDocumentKindClass
  ): TStrings;
begin

  Result := TStringList.Create;
  
  if UIDocumentKind.InheritsFrom(TUIOutcomingDocumentKind) then
  begin

    if (UIDocumentKind = TUIOutcomingServiceNoteKind)
    then begin

      Result.Add('�������');
      Result.Add('�� ����������');
      Result.Add('�� ����������');
      Result.Add('���������');
      Result.Add('���������');
      Result.Add('�� ������������');
      Result.Add('�����������');
      Result.Add('�� �����������');

    end

    else begin

      Result.Add('������');
      Result.Add('�� ����������');
      Result.Add('�� ����������');
      Result.Add('��������');
      Result.Add('��������');
      Result.Add('�� ������������');
      Result.Add('����������');
      Result.Add('�� ����������');

    end;

  end

  else if UIDocumentKind.InheritsFrom(TUIApproveableDocumentKind) then
  begin

    if UIDocumentKind = TUIApproveableServiceNoteKind then
    begin

      Result.Add('�������');
      Result.Add('�� ����������');
      Result.Add('�� ����������');
      Result.Add('���������');
      Result.Add('���������');
      Result.Add('�� ������������');
      Result.Add('�����������');
      Result.Add('�� �����������');

    end

    else begin

      Result.Add('������');
      Result.Add('�� ����������');
      Result.Add('�� ����������');
      Result.Add('��������');
      Result.Add('��������');
      Result.Add('�� ������������');
      Result.Add('����������');
      Result.Add('�� ����������');

    end;
    
  end
  
  else if UIDocumentKind.InheritsFrom(TUIIncomingDocumentKind) then begin

    if UIDocumentKind = TUIIncomingServiceNoteKind then begin

      Result.Add('�� ����������');
      Result.Add('���������');
      
    end

    else begin

      Result.Add('�� ����������');
      Result.Add('��������');

    end;

  end;
  
end;

class function TDocumentWorkCycleStageInfoReference.GetStageNumberOfCreatedForDocumentKind(
  UIDocumentKind: TUIDocumentKindClass
): Integer;
begin

  if UIDocumentKind.InheritsFrom(TUIOutcomingDocumentKind) then
      Result := 1

  else
    Result := -1

end;

class function TDocumentWorkCycleStageInfoReference.GetStageNumberOfPerformedForDocumentKind(
  UIDocumentKind: TUIDocumentKindClass): Integer;
begin

  if UIDocumentKind.InheritsFrom(TUIOutcomingDocumentKind) then
      Result := 8

  else if UIDocumentKind.InheritsFrom(TUIIncomingDocumentKind) then
      Result := 2

  else Result := 8;

end;

class function TDocumentWorkCycleStageInfoReference.GetStageNumberOfRejectedForDocumentKind(
  UIDocumentKind: TUIDocumentKindClass
): Integer;
begin

  if UIDocumentKind.InheritsFrom(TUIOutcomingDocumentKind) then
      Result := 6

  else if UIDocumentKind.InheritsFrom(TUIIncomingDocumentKind) then
      Result := -1

  else Result := 6;

end;

end.
