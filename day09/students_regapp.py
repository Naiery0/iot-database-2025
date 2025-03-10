# 학생 정보 등록 GUI앱
# pip install pymysql

# 1. 관련 모듈 임포트
import tkinter as tk
from tkinter import *
from tkinter import ttk,messagebox
from tkinter.font import * # 기본 외 폰트를 사용하려면

import pymysql # mysql-connector 등 다른 모듈도 추천

# 2. DB 관련 설정
host = 'localhost'
port = 3306
database = 'madang'
username = 'madang'
password = 'madang'

# 5. DB 처리 함수들 정의
## showDatas() - DB학생정보 테이블에 데이터를 가져와 TreeView에 표시
def showDatas():
    '''
    데이터베이스 내 모든 학생정보를 가져와 표시하는 함수
    '''
    global dataView
    ### DB연결 . 커넥션 객체 생성 -> 커서 -> 쿼리실행 -> 커서로 데이터 패치 -> 커서종료 -> 커넥션 종료
    conn = pymysql.connect(host=host, user=username, passwd=password, port=port, database=database) 
    cursor = conn.cursor() # DB 쿼리 실행 시 커서 생성

    ### 쿼리문 작성
    query = 'select std_id, std_name, std_mobile, std_regyear from students'
    cursor.execute(query=query) # 쿼리실행
    data = cursor.fetchall() # 쿼리 실행 데이터 전부 가져오기
    

    ### 가져온 데이터 트리뷰에 추가
    print(data)
    dataView.delete(*dataView.get_children())
    for i, (std_id, std_name, std_mobile, std_regyear) in enumerate(data, start=1):
        dataView.insert('', 'end', values=(std_id, std_name, std_mobile, std_regyear))
    
    cursor.close() # 커서 종료
    conn.close() # 커넥션 종료

# 6. getData(event) - 트리뷰 한 줄 더블클릭한 값 엔트리에 표시
def getData(event):
    '''
    트리뷰 더블클릭으로 선택된 학생정보를 엔트리 위젯에 채우는 사용자함수

    Args:
        event: 트리뷰에 발생하는 이벤트 객체
    '''
    global stdnum, ent1, ent2, ent3, ent4, dataView # 전역변수로 사용 선언
    
    ## 엔트리 위젯 기존 내용 삭제
    ent1.delete(0, END) # 학생번호 기존 데이터 삭제
    ent2.delete(0, END) # 학생명 기존 데이터 삭제
    ent3.delete(0, END) # 핸드폰 기존 데이터 삭제
    ent4.delete(0, END) # 입학년도 기존 데이터 삭제

    ## 트리뷰 선택항목 ID 가져오기('I001')
    sel_item = dataView.selection()

    if sel_item:
        item_values = dataView.item(sel_item, 'values') # 선택항목 'values'(실데이터) 가져오기

    ## 엔트리 위젯에 각각 채워넣기
    # ent1.insert(0, item_values[0]) # 학생번호
    stdnum.set(item_values[0])
    ent2.insert(0, item_values[1]) # 학생명
    ent3.insert(0, item_values[2]) # 핸드폰
    ent4.insert(0, item_values[3]) # 입학년도

# 7. 새 학생정보 추가 함수
def addData():
    '''
    새 학생정보 DB 테이블에 추가하는 함수
    '''
    global stdnum, ent1, ent2, ent3, ent4, dataView # 전역변수로 사용 선언

    ## 엔트리 위젯 학생정보 데이터 변수 할당
    std_name = ent2.get() # 학생명
    std_mobile = ent3.get() # 핸드폰
    std_regyear = ent4.get() # 입학년도

    ## DB연결
    conn = pymysql.connect(host=host, user=username, passwd=password, port=port, database=database) 
    cursor = conn.cursor() # DB 쿼리 실행 시 커서 생성
    
    try:
        conn.begin()  # begin 트랜잭션
        query = 'insert into students (std_name, std_mobile, std_regyear) values (%s, %s, %s)'
        val = (std_name, std_mobile, std_regyear)
        cursor.execute(query=query, args=val) # 쿼리실행

        conn.commit()  # 트랜잭션 확정
        lastid = cursor.lastrowid # 마지막에 insert된 레코드 id를 받아온다(auto_increment)
        print(lastid)

        messagebox.showinfo('INSERT', '학생등록 성공')
        
        ## 엔트리 위젯 기존 내용 삭제
        # ent1.delete(0, END) # 학생번호 기존 데이터 삭제
        stdnum.set('')
        ent2.delete(0, END) # 학생명 기존 데이터 삭제
        ent3.delete(0, END) # 핸드폰 기존 데이터 삭제
        ent4.delete(0, END) # 입학년도 기존 데이터 삭제
        ent2.focus_set() # 학생명 포커스

    except Exception as e:
        print(e)
        conn.rollback() # 트랜잭션 롤백
        messagebox.showerror('INSERT', '학생등록 실패')
    finally:
        cursor.close() # 커서
        conn.close() # 커넥션 종료
    
    showDatas()    

# 8. 기존학생정보 수정
def modData():
    '''
    기존 학생정보 수정 사용자 함수
    '''
    global ent1, ent2, ent3, ent4, dataView # 전역변수로 사용 선언

    ## 엔트리 위젯 학생정보 데이터 변수 할당
    std_id = ent1.get() # 학생번호
    std_name = ent2.get() # 학생명
    std_mobile = ent3.get() # 핸드폰
    std_regyear = ent4.get() # 입학년도
    
    if std_id == '':
        messagebox.showwarning('UPDATE', '수정할 데이터를 선택해주세요')
        return

    ## DB연결
    conn = pymysql.connect(host=host, user=username, passwd=password, port=port, database=database) 
    cursor = conn.cursor() # DB 쿼리 실행 시 커서 생성
    
    try:
        conn.begin()  # begin 트랜잭션
        query = 'update students set std_name=%s, std_mobile=%s, std_regyear=%s, where std_id=%s'
        val = (std_name, std_mobile, std_regyear, std_id)
        cursor.execute(query=query, args=val) # 쿼리실행

        conn.commit()  # 트랜잭션 확정
        lastid = cursor.lastrowid # 마지막에 insert된 레코드 id를 받아온다(auto_increment)
        print(lastid)

        messagebox.showinfo('UPDATE', '학생등록 성공')
        
        ## 엔트리 위젯 기존 내용 삭제
        # ent1.delete(0, END) # 학생번호 기존 데이터 삭제
        stdnum.set('')
        ent2.delete(0, END) # 학생명 기존 데이터 삭제
        ent3.delete(0, END) # 핸드폰 기존 데이터 삭제
        ent4.delete(0, END) # 입학년도 기존 데이터 삭제
        ent2.focus_set() # 학생명 포커스

    except Exception as e:
        print(e)
        conn.rollback() # 트랜잭션 롤백
        messagebox.showerror('UPDATE', '학생등록 실패')
    finally:
        cursor.close() # 커서
        conn.close() # 커넥션 종료
    
    showDatas()    

# 9. delData() 삭제함수

def delData():
    global stdnum,ent1, ent2, ent3, ent4, dataView # 전역변수로 사용 선언

    ## 엔트리 위젯 학생정보 데이터 변수 할당
    std_id = ent1.get() # 학생번호
    if std_id == '':
        messagebox.showwarning('DELETE', '삭제할 데이터를 선택해주세요')
        return
    
    ## DB연결
    conn = pymysql.connect(host=host, user=username, passwd=password, port=port, database=database) 
    cursor = conn.cursor() # DB 쿼리 실행 시 커서 생성
    
    try:
        conn.begin()  # begin 트랜잭션
        query = 'delete from students where std_id=%s'
        val = (std_id, ) # 삭제할 학생번호 튜플
        cursor.execute(query=query, args=val) # 쿼리실행

        conn.commit()  # 트랜잭션 확정
        lastid = cursor.lastrowid # 마지막에 insert된 레코드 id를 받아온다(auto_increment)
        print(lastid)

        messagebox.showinfo('DELETE', '학생삭제 성공')
        
        ## 엔트리 위젯 기존 내용 삭제
        # ent1.delete(0, END) # 학생번호 기존 데이터 삭제
        stdnum.set('')
        ent2.delete(0, END) # 학생명 기존 데이터 삭제
        ent3.delete(0, END) # 핸드폰 기존 데이터 삭제
        ent4.delete(0, END) # 입학년도 기존 데이터 삭제
        ent2.focus_set() # 학생명 포커스

    except Exception as e:
        print(e)
        conn.rollback() # 트랜잭션 롤백
        messagebox.showerror('DELETE', '학생삭제 실패')
    finally:
        cursor.close() # 커서
        conn.close() # 커넥션 종료
    
    showDatas()    


# 3. tkinter 윈도우 설정
root = Tk()                     # tkinter 윈도우 인스턴스 생성
root.geometry('820x500')        # 윈도우 크기 지정
root.title('학생정보 등록앱')   # 윈도우 타이틀
root.resizable(0, 0)            # 윈도우 사이즈 변경 불가
root.iconbitmap('./image/students.ico')

myFont = Font(family='NanumGothic', size=10)    # 이후에 화면 위젯에 지정할 동일폰트 생성

# 4. UI 구성
# 레이블
tk.Label(root, text='학생번호', font=myFont).place(x=10, y=10)
tk.Label(root, text='학생명', font=myFont).place(x=10, y=40)
tk.Label(root, text='핸드폰', font=myFont).place(x=10, y=70)
tk.Label(root, text='입학년도', font=myFont).place(x=10, y=100)

stdnum = StringVar()
# 엔트리(텍스트박스)
ent1 = tk.Entry(root, font=myFont, state='readonly', textvariable=stdnum)
# ent1.config(state='readonly') # 값 입력 못하게 방지
ent1.place(x=140, y=10) # 학생번호 Entry
ent2 = tk.Entry(root, font=myFont)
ent2.place(x=140, y=40) # 학생명 Entry
ent3 = tk.Entry(root, font=myFont)
ent3.place(x=140, y=70) # 핸드폰 Entry
ent4 = tk.Entry(root, font=myFont)
ent4.place(x=140, y=100) # 입학년도 Entry

# 버튼
tk.Button(root, text='추가', font=myFont, height=2, width=12, command=addData).place(x=30, y=130) # 추가버튼
tk.Button(root, text='수정', font=myFont, height=2, width=12, command=modData).place(x=140, y=130)
tk.Button(root, text='삭제', font=myFont, height=2, width=12, command=delData).place(x=250, y=130)

# 트리뷰
cols = ('학생번호', '학생명', '핸드폰', '입학년도')
dataView = ttk.Treeview(root, columns=cols, show='headings', height=14)

# 트리뷰 설정
for col in cols:
    dataView.heading(col, text=col) # 각 열 제목을 cols 변수 하나씩 지정
    dataView.grid(row=1, column=0, columnspan=2) # 트리뷰 위젯을 그리드 레이아웃에 배치
    dataView.place(x=10, y=180)

# 5. showData() 실행
showDatas()

# 6. 트리뷰 항목을 더블클릭하면 이벤트 발생(getData()함수 호출)
dataView.bind('<Double-Button-1>', func=getData)

# 3. 앱 실행
root.mainloop()



