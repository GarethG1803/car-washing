import { Entity, Column, ManyToOne } from 'typeorm';
import { BaseEntity } from '../../common/base.entity';
import { User } from '../../users/entities/user.entity';

@Entity('reviews')
export class Review extends BaseEntity {
  @ManyToOne(() => User, user => user.reviews)
  customer: User;

  @Column()
  customerId: string;

  @Column()
  washerId: string;

  @Column({ nullable: true })
  bookingId: string;

  @Column({ type: 'float' })
  rating: number;

  @Column({ type: 'text', nullable: true })
  comment: string;

  @Column({ type: 'simple-array', nullable: true })
  photoUrls: string[];

  @Column({ nullable: true })
  washerReply: string;
}
